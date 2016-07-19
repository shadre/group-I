# GitHub Workflow

## Creating a PR

You're working on an issue #32 that's tasks you with adding user stories
to the documentation.

Starting at branch `master` you create a new private, work-in-progress branch
named after the issue being solved and the subject of your work. As short as
possible, but still meaningful.

    git checkout master
    git checkout -b 32-user-stories

You're now on the newly created branch. Work and commit your changes. After
you're done and want to submit your work for a review.

First you need to see if any updates where pushed to `master` during your work:

    git fetch origin
    git log --all # or however you view the repo's history

If there were changes committed to `master` you should `merge` your local
`master` up to the new one. Also, you can get the same effect of `fetch` and
`merge` by using single `pull`, but that automates some things that you might
want to avoid when history gets complicated.

After updating your local `master` you can rebase your commits to on top of it:

    git rebase -i master

Pick all your commits, save the file, close editor and resolve any conflicts
along the way. Git prints helpful comments on how to proceed, so read the output
carefully.

When you're done, you can push your local branch to our GitHub repo (assuming
it's named `origin`):

    git push origin 32-user-stories

On repo's page you can compare your changes to `master`, and create the PR.

## Fixes to the PR

When you've got fixes to do on your PR, you just push new commits to the remote
branch.

    git push origin 32-user-stories

## Merging the PR

After all the fixes and after final approval you can merge the PR to the remote
`master`. First, update your remote refs, see if local `master` is up-to-date:

    git fetch origin

You should `merge` your local `master` to `origin/master` if needed.

Preparing your PR for merging will be a bit harder. You've got to do two things:

- again rebase all your changes on top of `master`
- squash all your small commits into larger pieces of bigger, logical changes

Luckily it's done in a single command:

    git rebase -i origin/master

You can go about this in two ways:

**Rebase then Squash**: You either rebase all the commits one-by-one — you leave
the `pick` option — and solve possible merge conflicts and commit basis. Then
after it's all rebased you run the same command, but this time you use `squash`
on all your commits.  
**Squash and Rebase**: You choose the `squash` option for all commits and pray
that there're no conflicts.

Now that you have a single (or few logically seperated) commits that can merge
into `master` on the remote repo without conflicts you're free to push it to
your remote branch. You have to `push --force`, because you're overwriting
previous, public history on the remote branch.

    git push --force origin 32-user-stories

After the push completes, go the PR's page and click the **Merge** button on the
bottom of the page.
