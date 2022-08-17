#!/bin/bash
set -e
export MODULE_PREFIX="$HOME/Installed_Package"
TEMP_DIR='temp'
mkdir -p logs
mkdir -p $TEMP_DIR
mkdir -p $MODULE_PREFIX

RED=$(tput setaf 1)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)

center() {
	termwidth="$(tput cols)"
	padding="$(printf '%0.1s' -{1..500})"
	printf '%*.*s %s %*.*s\n' 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

if [[ ! -f "$HOME/server-setup/logs/micromamba" ]]; then
	center "${GREEN}Downloading Micromamba${NORMAL}"
		curl -fsSL 'https://micro.mamba.pm/api/micromamba/linux-64/latest' -o ${TEMP_DIR}/micromamba.tar.bz2 \
			&& tar -xvf ${TEMP_DIR}/micromamba.tar.bz2 -C ${TEMP_DIR}
		mv ${TEMP_DIR}/bin ${MODULE_PREFIX}/bin
		touch $HOME/server-setup/logs/micromamba
fi

if [[ ! -f "$HOME/server-setup/logs/env_module" ]]; then
	center "${GREEN}Downloading Environment Module${NORMAL}"
		rm -rf ${TEMP_DIR}/v4.7.1.tar.gz ${TEMP_DIR}/modules-4.7.1
		wget https://github.com/cea-hpc/modules/archive/refs/tags/v4.7.1.tar.gz -P ${TEMP_DIR}
		tar -xvf ${TEMP_DIR}/v4.7.1.tar.gz -C ${TEMP_DIR}
		cd ${TEMP_DIR}/modules-4.7.1
		./configure --prefix=$MODULE_PREFIX/environment_modules --modulefilesdir=$MODULE_PREFIX/modules
		make -j 20 && make install
		cd ..
		rm -rf $MODULE_PREFIX/modules
		mv modules $MODULE_PREFIX/
		touch $HOME/server-setup/logs/env_module
fi