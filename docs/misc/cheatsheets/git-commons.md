# Most commonly used git commands

| Command                      | Description                                   | Examples                                                |
|------------------------------|-----------------------------------------------|---------------------------------------------------------|
| git init                     | Initialize a new Git repository               | git init                                                |
|                              |                                               | git init --bare                                         |
|                              |                                               |                                                         |
| git clone <repo>             | Clone an existing repository                  | git clone <repo_url>                                    |
|                              |                                               | git clone https://github.com/user/repo.git              |
|                              |                                               |                                                         |
| git status                   | Show working tree status                      | git status                                              |
|                              |                                               |                                                         |
| git add <file>               | Add file(s) to staging area                   | git add <file>                                          |
|                              |                                               | git add .                                               |
|                              |                                               | git add -A                                              |
|                              |                                               |                                                         |
| git commit -m "msg"          | Commit staged changes with a message          | git commit -m "Initial commit"                          |
|                              |                                               | git commit                # launches the default editor |
|                              |                                               |                                                         |
| git log                      | Show commit history                           | git log                                                 |
|                              |                                               | git log --oneline                                       |
|                              |                                               | git log --graph --decorate --all                        |
|                              |                                               |                                                         |
| git diff                     | Show changes between commits                  | git diff                                                |
|                              |                                               | git diff HEAD                                           |
|                              |                                               | git diff <commit1> <commit2>                            |
|                              |                                               |                                                         |
| git branch                   | List, create, or delete branches              | git branch                                              |
|                              |                                               | git branch new-branch                                   |
|                              |                                               | git branch -d old-branch                                |
|                              |                                               |                                                         |
| git checkout <branch>        | Switch branches or restore files              | git checkout <branch>                                   |
|                              |                                               | git checkout -b new-branch                              |
|                              |                                               | git checkout -- <file>                                  |
|                              |                                               |                                                         |
| git merge <branch>           | Merge a branch into the current branch        | git merge <branch>                                      |
|                              |                                               | git merge --no-ff <branch>                              |
|                              |                                               |                                                         |
| git pull                     | Fetch from remote and merge changes           | git pull                                                |
|                              |                                               | git pull origin master                                  |
|                              |                                               |                                                         |
| git push                     | Push commits to a remote repository           | git push                                                |
|                              |                                               | git push origin master                                  |
|                              |                                               | git push --force                                        |
|                              |                                               |                                                         |
| git cherry-pick <commit>     | Apply changes from a specific commit          | git cherry-pick <commit>                                |
|                              |                                               | git cherry-pick -n <commit>                             |
|                              |                                               |                                                         |
| git revert <commit>          | Revert a commit by creating a new commit      | git revert <commit>                                     |
|                              |                                               | git revert -n <commit>                                  |
|                              |                                               |                                                         |
| git tag                      | List, create, or delete tags                  | git tag -a v<version> [<sha>] -m "<description>"        |
|                              |                                               | git tag -d v<version>                                   |
|                              |                                               | git tag -l "v<tag>*"                                    |
|                              |                                               |                                                         |
| git stash                    | Stash current changes temporarily             | git stash                                               |
|                              |                                               | git stash save "work in progress"                       |
|                              |                                               |                                                         |
| git stash pop                | Reapply stashed changes and remove from stash | git stash pop                                           |
|                              |                                               | git stash pop stash@{0}                                 |
|                              |                                               |                                                         |
| git reset [mode] <commit>    | Reset current HEAD to a specified commit      | git reset --hard <commit>                               |
|                              |                                               | git reset --soft <commit>                               |
|                              |                                               | git reset <file>                                        |
|                              |                                               |                                                         |
| git fetch                    | Download objects and refs from a remote       | git fetch                                               |
|                              |                                               | git fetch origin                                        |
|                              |                                               |                                                         |
| git rebase <branch>          | Reapply commits on top of another base tip    | git rebase <branch>                                     |
|                              |                                               | git rebase -i <commit>                                  |
|                              |                                               |                                                         |
| git remote -v                | Show remote repository details                | git remote -v                                           |
| ---------------------------  |                                               |                                                         |
| git show <commit>            | Display information about a specific commit   | git show <commit>                                       |
|                              |                                               | git show --stat <commit>                                |
