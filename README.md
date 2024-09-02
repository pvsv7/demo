Here’s how you can document the steps in Confluence:

---

### **Branch Development and Rebase Process**

#### **1. Create a Feature Branch**
- Start by creating a new branch for your feature development:
  ```bash
  git checkout -b feature-branch-name
  ```
- Develop and commit your changes on this branch as needed.

#### **2. Update Local Master Branch**
- Switch to the `master` branch:
  ```bash
  git checkout master
  ```
- Pull the latest changes from the remote `master` to ensure your local `master` is up-to-date:
  ```bash
  git pull origin master
  ```

#### **3. Rebase Feature Branch onto Master**
- Switch back to your feature branch:
  ```bash
  git checkout feature-branch-name
  ```
- Rebase your feature branch onto the updated `master`:
  ```bash
  git rebase -i master
  ```
- In the interactive rebase editor:
  - Leave the first commit as `pick`.
  - Change all subsequent commits from `pick` to `f` (short for `fixup`), which squashes them into the first commit without keeping their commit messages.

#### **4. Save and Complete the Rebase**
- After editing the rebase file, save and close the editor. The rebase process will continue, applying your changes onto the latest `master`.

#### **5. Force Push the Feature Branch**
- Since the rebase rewrites the commit history, you need to force push your changes to update the remote feature branch:
  ```bash
  git push -f origin feature-branch-name
  ```

### **Purpose of This Process**
- **Keeping a Clean Commit History**: Squashing commits before pushing ensures that your feature branch has a clean, single commit that reflects the entire feature or fix. This is especially useful when preparing a branch for a pull request.
  
- **Staying Up-to-Date with Master**: Rebasing your branch onto the latest `master` ensures that your feature branch is current, reducing the likelihood of merge conflicts when your changes are integrated.

### **Best Practices**
- Always ensure your local `master` is up-to-date before rebasing.
- Use `fixup` (`f`) during interactive rebase to combine commits without keeping unnecessary commit messages.
- Force push only when necessary and communicate with your team to avoid overwriting important remote history.

---

This documentation provides clear instructions on the process and explains the purpose behind each step, which will be useful for anyone following along in Confluence.
