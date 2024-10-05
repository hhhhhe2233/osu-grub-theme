#!/bin/bash

# Grub2 Theme

ROOT_UID=0
THEME_DIR="/boot/grub/themes"
THEME_NAME=osu
MAX_DELAY=20                                        # 用户输入suwd的最大超时时间

#COLORS
CDEF=" \033[0m"                                     # 默认颜色
CCIN=" \033[0;36m"                                  # 信息颜色
CGSC=" \033[0;32m"                                  # 成功色
CRER=" \033[0;31m"                                  # 错误色
CWAR=" \033[0;33m"                                  # 警告色
b_CDEF=" \033[1;37m"                                # 粗体默认颜色
b_CCIN=" \033[1;36m"                                # 粗体信息颜色
b_CGSC=" \033[1;32m"                                # 粗体成功色
b_CRER=" \033[1;31m"                                # 粗体错误色
b_CWAR=" \033[1;33m"                                # 粗体警告色

# echo like ...  with  flag type  and display message  输出 ... 带标志类型和显示消息颜色
prompt () {
  case ${1} in
    "-s"|"--success")
      echo -e "${b_CGSC}${@/-s/}${CDEF}";;          # print success message
    "-e"|"--error")
      echo -e "${b_CRER}${@/-e/}${CDEF}";;          # print error message
    "-w"|"--warning")
      echo -e "${b_CWAR}${@/-w/}${CDEF}";;          # print warning message
    "-i"|"--info")
      echo -e "${b_CCIN}${@/-i/}${CDEF}";;          # print info message
    *)
    echo -e "$@"
    ;;
  esac
}

# Welcome message
prompt -s "\n\t************************\n\t*  ${THEME_NAME} - Grub2 Theme  *\n\t************************"

# Check command avalibility
function has_command() {
  command -v $1 > /dev/null
}

# Checking for root access and proceed if it is present
if [ "$UID" -eq "$ROOT_UID" ]; then

  # Create themes directory if not exists
  prompt -i "\nChecking directory...\n"
  [[ -d ${THEME_DIR}/${THEME_NAME} ]] && rm -rf ${THEME_DIR}/${THEME_NAME}
  mkdir -p "${THEME_DIR}/${THEME_NAME}"

  # Copy theme
  prompt -i "\nInstalling theme...\n"

  cp -a ${THEME_NAME}/* ${THEME_DIR}/${THEME_NAME}

  # Set theme
  prompt -i "\nSetting the theme as main...\n"

  # Backup grub config
  cp -an /etc/default/grub /etc/default/grub.bak

  grep "GRUB_THEME=" /etc/default/grub 2>&1 >/dev/null && sed -i '/GRUB_THEME=/d' /etc/default/grub

  echo "GRUB_THEME=\"${THEME_DIR}/${THEME_NAME}/theme.txt\"" >> /etc/default/grub

  echo "GRUB_GFXMODE=1920x1080" >> /etc/default/grub

  # Update grub config
  echo -e "Updating grub..."
  if has_command update-grub; then
    update-grub
  elif has_command grub-mkconfig; then
    grub-mkconfig -o /boot/grub/grub.cfg
  elif has_command grub2-mkconfig; then
    if has_command zypper; then
      grub2-mkconfig -o /boot/grub2/grub.cfg
    elif has_command dnf; then
      grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
    fi
  fi

  # Success message
  prompt -s "\n\t          ***************\n\t          *  installed!  *\n\t          ***************\n"

else

  # Error message
  prompt -e "\n [ Error! ] -> Run me as root "

  # persisted execution of the script as root
  read -p "[ trusted ] specify the root password : " -t${MAX_DELAY} -s
  [[ -n "$REPLY" ]] && {
    sudo -S <<< $REPLY $0
  } || {
    prompt  "\n Operation canceled"
    exit 1
  }
fi
