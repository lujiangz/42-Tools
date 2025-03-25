#!/bin/bash

clear

COLUMNS=$(tput cols)

ascii_art=(
"████                  ███   ███                                          "
"░░███                 ░░░   ░░░                                           "
" ░███  █████ ████     █████ ████   ██████   ████████    ███████  █████████"
" ░███ ░░███ ░███     ░░███ ░░███  ░░░░░███ ░░███░░███  ███░░███ ░█░░░░███ "
" ░███  ░███ ░███      ░███  ░███   ███████  ░███ ░███ ░███ ░███ ░   ███░  "
" ░███  ░███ ░███      ░███  ░███  ███░░███  ░███ ░███ ░███ ░███   ███░   █"
" █████ ░░████████     ███  █████░░████████ ████ █████░░███████  █████████"
"░░░░░   ░░░░░░░░      ░███ ░░░░░  ░░░░░░░░ ░░░░ ░░░░░  ░░░░░███ ░░░░░░░░░ "
"                  ███ ░███                             ███ ░███           "
"                 ░░██████                             ░░██████            "
"                  ░░░░░░                               ░░░░░░             "
)

menu_lines=(
"================ DOWNLOAD LUJI'S TOOLS FOR 42 ECOLE ================"
""
"1. Ghidra"
"2. Obsidian"
"3. Wireshark"
"4. Exit"
""
"Select an option (1-4): "
)

for line in "${ascii_art[@]}"; do
    line_length=${#line}
    padding=$(( (COLUMNS - line_length) / 2 ))
    printf "%${padding}s%s\n" "" "$line"
done

echo ""

for i in "${!menu_lines[@]}"; do
    line="${menu_lines[$i]}"
    line_length=${#line}
    padding=$(( (COLUMNS - line_length) / 2 ))
    if [ $i -eq $((${#menu_lines[@]} - 1)) ]; then
        printf "%${padding}s%s" "" "$line"
        read choice
    else
        printf "%${padding}s%s\n" "" "$line"
    fi
done

case $choice in
    1)
        clear
        for line in "${ascii_art[@]}"; do
            line_length=${#line}
            padding=$(( (COLUMNS - line_length) / 2 ))
            printf "%${padding}s%s\n" "" "$line"
        done
        echo ""

        sub_menu_lines=(
        "================ GHIDRA INSTALLER ================"
        ""
        "Which parameter would you like to use?"
        "i for install, u to delete archives, r to reinstall"
        ""
        "Enter your choice (i/u/r): "
        )

        for i in "${!sub_menu_lines[@]}"; do
            line="${sub_menu_lines[$i]}"
            line_length=${#line}
            padding=$(( (COLUMNS - line_length) / 2 ))
            if [ $i -eq $((${#sub_menu_lines[@]} - 1)) ]; then
                printf "%${padding}s%s" "" "$line"
                read sub_choice
            else
                printf "%${padding}s%s\n" "" "$line"
            fi
        done

        ghidra_script_url="https://raw.githubusercontent.com/lujiangz/42-Tools/refs/heads/main/Ghidra/ghidra_install.sh"
        ghidra_script="ghidra_install.sh"

        echo "Downloading Ghidra installer..."
        wget -O "$ghidra_script" "$ghidra_script_url" > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "Failed to download Ghidra installer! Check your internet connection."
            exit 1
        fi

        chmod +x "$ghidra_script"

        case $sub_choice in
            i | I)
                echo "Installing Ghidra with -i parameter..."
                bash "$ghidra_script" -i
                ;;
            u | U)
                echo "Uninstalling Ghidra with -u parameter..."
                bash "$ghidra_script" -u
                ;;
            r | R)
                echo "Reinstalling Ghidra with -r parameter..."
                bash "$ghidra_script" -r
                ;;
            *)
                echo "Invalid choice! Please select i, u, or r."
                ;;
        esac

        rm -f "$ghidra_script"
        echo "Press Enter to return to the main menu..."
        read X
        bash "$0"
        exit 0
        ;;
    2)
        clear
        for line in "${ascii_art[@]}"; do
            line_length=${#line}
            padding=$(( (COLUMNS - line_length) / 2 ))
            printf "%${padding}s%s\n" "" "$line"
        done
        echo ""

        sub_menu_lines=(
        "================ OBSIDIAN DOWNLOADER ================"
        ""
        "Downloading the latest Obsidian AppImage..."
        )

        for line in "${sub_menu_lines[@]}"; do
            line_length=${#line}
            padding=$(( (COLUMNS - line_length) / 2 ))
            printf "%${padding}s%s\n" "" "$line"
        done

        obsidian_releases_url="https://github.com/obsidianmd/obsidian-releases/releases"
        latest_release_url=$(curl -s $obsidian_releases_url | grep -oP 'href="/obsidianmd/obsidian-releases/releases/tag/v[0-9]+\.[0-9]+\.[0-9]+"' | head -1 | cut -d'"' -f2)
        full_release_url="https://github.com$latest_release_url"

        appimage_url=$(curl -s "$full_release_url" | grep -oP 'href="/obsidianmd/obsidian-releases/releases/download/v[0-9]+\.[0-9]+\.[0-9]+/Obsidian-[0-9]+\.[0-9]+\.[0-9]+\.AppImage"' | head -1 | cut -d'"' -f2)
        full_appimage_url="https://github.com$appimage_url"

        if [ -z "$full_appimage_url" ]; then
            echo "Failed to find the latest Obsidian AppImage! Check the releases page."
            echo "Press Enter to return to the main menu..."
            read X
            bash "$0"
            exit 0
        fi

        obsidian_appimage="Obsidian.AppImage"
        echo "Downloading Obsidian from $full_appimage_url..."
        wget -O "$obsidian_appimage" "$full_appimage_url" > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "Failed to download Obsidian! Check your internet connection."
            echo "Press Enter to return to the main menu..."
            read X
            bash "$0"
            exit 0
        fi

        chmod +x "$obsidian_appimage"

        sub_menu_lines=(
        ""
        "Obsidian has been downloaded successfully!"
        "File: $obsidian_appimage"
        ""
        "Would you like to run Obsidian now? (y/n): "
        )

        for i in "${!sub_menu_lines[@]}"; do
            line="${sub_menu_lines[$i]}"
            line_length=${#line}
            padding=$(( (COLUMNS - line_length) / 2 ))
            if [ $i -eq $((${#sub_menu_lines[@]} - 1)) ]; then
                printf "%${padding}s%s" "" "$line"
                read run_choice
            else
                printf "%${padding}s%s\n" "" "$line"
            fi
        done

        case $run_choice in
            y | Y)
                echo "Running Obsidian..."
                ./$obsidian_appimage &
                ;;
            *)
                echo "Obsidian AppImage is saved as $obsidian_appimage. You can run it manually."
                ;;
        esac

        echo "Press Enter to return to the main menu..."
        read X
        bash "$0"
        exit 0
        ;;
    3)
        clear
        for line in "${ascii_art[@]}"; do
            line_length=${#line}
            padding=$(( (COLUMNS - line_length) / 2 ))
            printf "%${padding}s%s\n" "" "$line"
        done
        echo ""

        sub_menu_lines=(
        "================ WIRESHARK DOWNLOADER ================"
        ""
        "Downloading Wireshark AppImage..."
        )

        for line in "${sub_menu_lines[@]}"; do
            line_length=${#line}
            padding=$(( (COLUMNS - line_length) / 2 ))
            printf "%${padding}s%s\n" "" "$line"
        done

        wireshark_appimage_url="https://github.com/lujiangz/42-Tools/raw/main/Network/Wireshark-4.4.2.glibc2.29-x86_64-1_JB.AppImage"
        wireshark_appimage="Wireshark.AppImage"

        echo "Downloading Wireshark from $wireshark_appimage_url..."
        wget -O "$wireshark_appimage" "$wireshark_appimage_url" > /dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "Failed to download Wireshark! Check your internet connection."
            echo "Press Enter to return to the main menu..."
            read X
            bash "$0"
            exit 0
        fi

        chmod +x "$wireshark_appimage"

        sub_menu_lines=(
        ""
        "Wireshark has been downloaded successfully!"
        "File: $wireshark_appimage"
        ""
        "Would you like to run Wireshark now? (y/n): "
        )

        for i in "${!sub_menu_lines[@]}"; do
            line="${sub_menu_lines[$i]}"
            line_length=${#line}
            padding=$(( (COLUMNS - line_length) / 2 ))
            if [ $i -eq $((${#sub_menu_lines[@]} - 1)) ]; then
                printf "%${padding}s%s" "" "$line"
                read run_choice
            else
                printf "%${padding}s%s\n" "" "$line"
            fi
        done

        case $run_choice in
            y | Y)
                echo "Running Wireshark..."
                ./$wireshark_appimage &
                ;;
            *)
                echo "Wireshark AppImage is saved as $wireshark_appimage. You can run it manually."
                ;;
        esac

        echo "Press Enter to return to the main menu..."
        read X
        bash "$0"
        exit 0
        ;;
    4)
        clear
        sub_menu_lines=(
        "================ GOODBYE FROM LUJI'S TOOLS ================"
        ""
        "Thank you for using Luji's Tools for 42 Ecole!"
        "See you next time!"
        ""
        "Press Enter to exit..."
        )

        for line in "${sub_menu_lines[@]}"; do
            line_length=${#line}
            padding=$(( (COLUMNS - line_length) / 2 ))
            printf "%${padding}s%s\n" "" "$line"
        done
        read X
        exit 0
        ;;
    *)
        echo "Invalid option! Please select a number between 1 and 4."
        echo "Press Enter to return to the main menu..."
        read X
        bash "$0"
        exit 0
        ;;
esac
