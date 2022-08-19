#!/bin/bash
set -e
export MODULE_PREFIX="$HOME/Installed_Package"
TEMP_DIR="temp"
CURR_DIR="$PWD"
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
	printf "%*.*s %s %*.*s\n" 0 "$(((termwidth-2-${#1})/2))" "$padding" "$1" 0 "$(((termwidth-1-${#1})/2))" "$padding"
}

if [[ ! -f "$CURR_DIR/logs/micromamba" ]]; then
	center "${GREEN}Downloading Micromamba${NORMAL}"
		curl -fSL "https://micro.mamba.pm/api/micromamba/linux-64/latest" -o ${TEMP_DIR}/micromamba.tar.bz2 \
			&& tar -xvf ${TEMP_DIR}/micromamba.tar.bz2 -C ${TEMP_DIR}
		mv ${TEMP_DIR}/bin ${MODULE_PREFIX}/bin
		touch $CURR_DIR/logs/micromamba
fi

if [[ ! -f "$CURR_DIR/logs/env_module" ]]; then
	center "${GREEN}Setting up Environment Module${NORMAL}"
		.${MODULE_PREFIX}/bin/micromamba -n environment_modules environment-modules -c conda-forge -r ${MODULE_PREFIX}
fi

# if [[ ! -f "$CURR_DIR/logs/env_module" ]]; then
# 	center "${GREEN}Downloading Environment Module${NORMAL}"
# 		rm -rf ${TEMP_DIR}/v4.7.1.tar.gz ${TEMP_DIR}/modules-4.7.1
# 		wget https://github.com/cea-hpc/modules/archive/refs/tags/v4.7.1.tar.gz -P ${TEMP_DIR}
# 		tar -xvf ${TEMP_DIR}/v4.7.1.tar.gz -C ${TEMP_DIR}
# 		cd ${TEMP_DIR}/modules-4.7.1
# 		./configure --prefix=$MODULE_PREFIX/environment_modules --modulefilesdir=$MODULE_PREFIX/modules
# 		make -j 20 && make install
# 		rm -rf $MODULE_PREFIX/modules
# 		cp -r $CURR_DIR/modules $MODULE_PREFIX/
# 		touch $CURR_DIR/logs/env_module
# fi

# if [[ ! -f "$CURR_DIR/logs/default_env" ]]; then
# 	center "${GREEN}Setting up default environment${NORMAL}"
# 	. $MODULE_PREFIX/environment_modules/init/bash
# 	module avail
# 	module load mamba \
# 		&& mamba create -y -f $CURR_DIR/envs/default.yaml
# 	touch $CURR_DIR/logs/default_env
# fi

# if [[ ! -f "$CURR_DIR/logs/module_bash" ]]; then
# 	center "${GREEN}Appending lines to bashrc${NORMAL}"
# 		echo 'export MODULE_PREFIX="$HOME/Installed_Package"' >> ~/.bash_profile
# 		echo '. $MODULE_PREFIX/environment_modules/init/bash' >> ~/.bash_profile
# 		echo "module load mamba default" >> $MODULE_PREFIX/environment_modules/init/modulerc
# 		touch $CURR_DIR/logs/module_bash
# 	center "${GREEN}Completed${NORMAL}"
# fi