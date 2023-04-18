FROM gitpod/workspace-mysql

USER root

SHELL ["/bin/bash", "-c"]

# Install other needed packages
RUN add-apt-repository -y ppa:ondrej/php
RUN add-apt-repository -y ppa:ondrej/apache2
RUN sudo apt update -y
RUN sudo apt upgrade -y
RUN sudo update-alternatives --set php $(which php8.1)
RUN sudo apt install -y php-mysql curl php8.1-curl php8.1-gd php8.1-mbstring php-pear php-apcu php-json php-xdebug build-essential sendmail
RUN pecl install apcu
RUN pecl install uploadprogress

#Copy configuration files
COPY .gitpod/php.ini /etc/php/8.1/apache2/php.ini
COPY .gitpod/apache2.conf /etc/apache2/apache2.conf

# Install latest composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php --install-dir /usr/bin --filename composer
RUN php -r "unlink('composer-setup.php');"

# Install pa11y accessibility testing tool, including NodeJS and Chromium
RUN curl -sL https://deb.nodesource.com/setup_16.x -o nodesource_setup.sh
RUN bash nodesource_setup.sh
RUN apt-get install -y nodejs libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm-amdgpu1 libxkbcommon-x11-0 libxcomposite-dev libxdamage-dev libxrandr-dev libgbm-dev libgtk-3-common libxshmfence-dev software-properties-common
RUN apt-get install -y apparmor snapd apparmor-profiles-extra apparmor-utils kdialog chromium-browser libappindicator1 fonts-liberation
RUN npm install pa11y -g --unsafe-perm=true --allow-root

# Expose Apache and MySQL
EXPOSE 80
EXPOSE 443
EXPOSE 3306
