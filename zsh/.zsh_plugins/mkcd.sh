mkcd() {
    # Prompt the user for input
    echo -n "Enter the directory name: "
    read directory_name

    # Use mkdir -p to create the directory and any necessary parent directories
    if mkdir -p "$directory_name"; then
        # echo "Directory '$directory_name' created successfully or already exists."
        echo "DONE!"
        cd "$directory_name" || { echo "Error: Failed to change to directory '$directory_name'."; return 1; }
    else
        echo "Error: Failed to create directory '$directory_name'."
        return 1
    fi
}
