#!/bin/bash
# Define a function to set the color of the input prompt
function color_input_prompt {
    echo -e "\033[32m$1\033[0m"
}

current_branch=$(git symbolic-ref --short HEAD)

if [ "$current_branch" = "master" ]; then
    read -p "$(color_input_prompt "Enter the branch name: ")" new_branch
    
    # Check if the branch exists
    if git show-ref --verify --quiet "refs/heads/$new_branch"; then
        git checkout "$new_branch"
        echo "\033[32mChecked out to branch: $new_branch\033[0m"
    else
        echo "\033[32mBranch '$new_branch' does not exist, so creating new branch $new_branch \033[0m"
        git checkout -b "$new_branch"
    fi
    # Set the value of current_branch to new_branch
    current_branch="$new_branch"
fi

# Check if any files other than web.sh have been modified
# if [[ $(git diff --name-only --ignore-submodules | grep -v "web.sh") ]]; then
# Add all files except web.sh
git add .        # Add all files
# git reset web.sh # Unstage web.sh file

read -p "Enter the commit message: " commit_message

# Store the commit message in a variable
commit_msg="$commit_message"

# Use the commit message as needed
echo -e "\033[32m\nCommit message: $current_branch $commit_msg\033[0m"


git commit -m "$current_branch $commit_msg"
# fi

# Ask user to skip verification step with default value "Y"
skip_verification="Y"
# read -t 5 -p "\033[32m Pushing code on GitHub, skip verification? (Y/n):\033[0m " skip_verification
echo -e "\033[32mPushing code on GitHub, skip verification? (Y/n):\033[0m"
read -t 5 skip_verification

echo

if [[ "$skip_verification" =~ ^[Yy]$ ]] || [[ -z "$skip_verification" ]]; then
    echo -e "\033[32mpushing code to : $current_branch with no-verification \033[0m"
    git push origin "$current_branch" --no-verify
    echo -e "\033[0mpushed created to $current_branch without verification. \033[0m"
else
    git push origin "$current_branch"
    echo -e "\033[32mcode pushed to $current_branch with verification \033[0m"
fi
