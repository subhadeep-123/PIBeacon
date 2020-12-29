FROM balenalib/rpi-raspbian

# Configure
# EXPOSE 5551
WORKDIR /app

# Copy Files
COPY bootstrap /bootstrap
COPY app /app

# Install Requirements
RUN apt-get update -y
# RUN apt-get dist-upgrade -y
# RUN apt-get upgrade -y
RUN apt-get install -y $(cat /bootstrap/deps/apt.list | tr '\n' ' ')
#RUN pip3 install --upgrade pip
#RUN pip3 install -r /bootstrap/deps/pip.list
RUN apt-get clean

# Setting Up Entrypoint
ENTRYPOINT sh docker_setup.sh
