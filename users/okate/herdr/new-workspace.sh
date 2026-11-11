# herdr-new-workspace: create a purpose-centric workspace spanning several repos
#
#   ~/src/<repo>/                         origin checkout (base branch)
#   ~/src/.envrc.common                   variables shared by every repo
#   ~/src/.envrc.<repo>                   variables specific to <repo>
#   ~/src/workspaces/<slug>/              one directory per purpose
#   ~/src/workspaces/<slug>/<repo>/       git worktree of <repo> on <branch>
#
# <slug> is the branch name with "/" replaced by "-" (work/foo -> work-foo).
# Runs from a herdr popup keybinding:
#   1. asks for the branch name
#   2. lets you pick repositories under ~/src with fzf (multi-select)
#   3. creates the worktrees (new branches start from each repo's origin/HEAD)
#      and sets up direnv for each of them
#   4. opens (or reuses) one herdr workspace labelled <slug> whose first tab
#      sits in ~/src/workspaces/<slug> and adds one tab per repository
# Running it again with the same branch adds repositories to the workspace.

SRC_ROOT="${HERDR_SRC_ROOT:-$HOME/src}"
WORKSPACES_ROOT="$SRC_ROOT/workspaces"
HERDR="${HERDR_BIN_PATH:-herdr}"

pause() {
  printf '\n%s' "Press Enter to close..."
  read -r _ || true
}

die() {
  printf 'error: %s\n' "$*" >&2
  pause
  exit 1
}

warn() {
  printf '  ! %s\n' "$*" >&2
}

# origin repo of the focused pane (listed first in the picker)
current_repo=""
cwd="${HERDR_ACTIVE_PANE_CWD:-$PWD}"
if common_dir=$(git -C "$cwd" rev-parse --path-format=absolute --git-common-dir 2>/dev/null); then
  current_repo=$(basename "$(dirname "$common_dir")")
fi

read -r -e -p "branch name (e.g. work/foo): " branch || exit 0
[ -n "$branch" ] || exit 0
git check-ref-format --branch "$branch" >/dev/null 2>&1 || die "invalid branch name: $branch"
slug=${branch//\//-}
ws_dir="$WORKSPACES_ROOT/$slug"

# candidate repositories: ~/src/<name>/.git directories, not yet in this workspace
candidates=()
for git_dir in "$SRC_ROOT"/*/.git; do
  [ -d "$git_dir" ] || continue
  name=$(basename "$(dirname "$git_dir")")
  [ "$name" = "workspaces" ] && continue
  [ -e "$ws_dir/$name" ] && continue
  if [ "$name" = "$current_repo" ]; then
    candidates=("$name" "${candidates[@]}")
  else
    candidates+=("$name")
  fi
done
[ "${#candidates[@]}" -gt 0 ] || die "no repositories left to add to $slug"

mapfile -t repos < <(printf '%s\n' "${candidates[@]}" \
  | fzf --multi --height=~100% --reverse \
      --header="workspace: $slug  (TAB: select, Enter: confirm)" \
      --prompt="repos> ") || exit 0
[ "${#repos[@]}" -gt 0 ] || exit 0

setup_direnv() {
  local origin=$1 dest=$2 repo=$3 f rel p list
  local allow=()

  if [ ! -e "$dest/.envrc" ]; then
    printf 'source_up .envrc.%s\n' "$repo" > "$dest/.envrc"
    allow+=("$dest/.envrc")
  fi

  # nested .envrc files of sub-projects
  while IFS= read -r -d '' f; do
    rel=${f#"$origin"/}
    [ -d "$dest/$(dirname "$rel")" ] || continue
    if [ ! -e "$dest/$rel" ]; then
      cp -a "$f" "$dest/$rel"
      allow+=("$dest/$rel")
    fi
  done < <(find "$origin" -mindepth 2 \( -name .git -o -name node_modules -o -name .venv -o -name .devenv -o -name .devbox -o -name .direnv \) -prune -o -name .envrc -type f -print0)

  # ignored files listed per repo (one relative path per line, # for comments)
  list="$SRC_ROOT/.worktree-copy.$repo"
  if [ -f "$list" ]; then
    while IFS= read -r p || [ -n "$p" ]; do
      case "$p" in '' | '#'*) continue ;; esac
      [ -e "$origin/$p" ] || continue
      (cd "$origin" && cp -a -n --parents "$p" "$dest/")
    done < "$list"
  fi

  for f in "${allow[@]}"; do
    direnv allow "$f"
  done
}

mkdir -p "$ws_dir"
created=()
printf '\nworkspace: %s\n' "$ws_dir"
for repo in "${repos[@]}"; do
  origin="$SRC_ROOT/$repo"
  dest="$ws_dir/$repo"
  printf '\n[%s]\n' "$repo"

  if ! git -C "$origin" rev-parse -q --verify HEAD >/dev/null; then
    warn "no commits yet, skipped"
    continue
  fi

  if git -C "$origin" show-ref --verify --quiet "refs/heads/$branch"; then
    git -C "$origin" worktree add "$dest" "$branch" || { warn "git worktree add failed, skipped"; continue; }
  elif [ "$(git -C "$origin" for-each-ref --count=1 "refs/remotes/*/$branch")" ]; then
    # existing remote branch: let git create a tracking branch
    git -C "$origin" worktree add "$dest" "$branch" || { warn "git worktree add failed, skipped"; continue; }
  else
    base=$(git -C "$origin" symbolic-ref -q --short refs/remotes/origin/HEAD 2>/dev/null \
      || git -C "$origin" branch --show-current)
    [ -n "$base" ] || base=HEAD
    printf '  new branch %s from %s\n' "$branch" "$base"
    # --no-track: do not make origin/<base> the upstream of the new branch
    git -C "$origin" worktree add --no-track -b "$branch" "$dest" "$base" || { warn "git worktree add failed, skipped"; continue; }
  fi

  setup_direnv "$origin" "$dest" "$repo"
  created+=("$repo")
done

if [ "${#created[@]}" -eq 0 ]; then
  rmdir "$ws_dir" 2>/dev/null || true
  die "no worktree was created"
fi

# herdr: one workspace per purpose, one tab per repository
ws_id=$("$HERDR" workspace list \
  | jq -r --arg l "$slug" 'first(.result.workspaces[] | select(.label == $l) | .workspace_id) // empty')
if [ -z "$ws_id" ]; then
  out=$("$HERDR" workspace create --cwd "$ws_dir" --label "$slug" --no-focus)
  ws_id=$(printf '%s' "$out" | jq -r '.result.workspace.workspace_id')
  "$HERDR" tab rename "$(printf '%s' "$out" | jq -r '.result.tab.tab_id')" "$slug" >/dev/null
fi
for repo in "${created[@]}"; do
  "$HERDR" tab create --workspace "$ws_id" --cwd "$ws_dir/$repo" --label "$repo" --no-focus >/dev/null
done
"$HERDR" workspace focus "$ws_id" >/dev/null

printf '\ncreated in %s: %s\n' "$ws_dir" "${created[*]}"
