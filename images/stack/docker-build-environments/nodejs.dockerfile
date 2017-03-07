FROM evarga/jenkins-slave

RUN apt-get update && apt-get -y install \
	software-properties-common \
	wget \
	zip \
	unzip \
	git \
	curl

# RUN echo "deb http://dl.google.com/linux/chrome/deb/ stable main" | tee -a /etc/apt/sources.list
# RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

# RUN apt-get update && apt-get -y install \
#	libxpm4 libxrender1 libgtk2.0-0 libnss3 libgconf-2-4 \
#	google-chrome-stable \
#	xvfb gtk2-engines-pixbuf \
#	xfonts-cyrillic xfonts-100dpi xfonts-75dpi xfonts-base xfonts-scalable \
#	imagemagick x11-apps

# RUN Xvfb -ac :99 -screen 0 1280x1024x16 &

RUN curl --silent --location https://deb.nodesource.com/setup_6.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm install bower -g

RUN chsh -s /bin/bash jenkins

COPY nodejs-env.sh /home/jenkins/.bashrc

