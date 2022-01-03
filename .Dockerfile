FROM gitpod/workspace-mysql

USER root

SHELL ["/bin/bash", "-c"]

# Install other needed packages
RUN add-apt-repository -y ppa:ondrej/apache2
RUN apt update
RUN apt install -y php-pear php-apcu php-json php-xdebug build-essential
RUN pecl install apcu
RUN pecl install uploadprogress

#Copy configuration files
COPY /conf/apache2.conf /etc/apache2/apache2.conf
COPY /conf/php.ini /etc/php/8.0/apache2/php.ini

# Install latest composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --install-dir /usr/bin --filename composer
RUN php -r "unlink('composer-setup.php');"

#Install pa11y accessibility testing tool, including NodeJS
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
RUN apt-get install -y nodejs libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm-amdgpu1 libxkbcommon-x11-0 libxcomposite-dev libxdamage-dev libxrandr-dev libgbm-dev libgtk-3-common libxshmfence-dev
RUN npm install pa11y-ci -g --unsafe-perm=true --allow-root

#Add drush aliases
RUN echo 'alias drush=/workspace/Drupal-GitPod/vendor/drush/drush/drush' >> ~/.bashrc
RUN echo 'alias drush content-sync:export="drush content-sync:export --entity-types=block_content,file,menu_link_content,node"' >> ~/.bashrc
RUN source ~/.bashrc

#Expose Apache and MySQL
EXPOSE 80
EXPOSE 443
EXPOSE 3306
