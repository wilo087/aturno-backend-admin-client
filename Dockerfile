FROM node:10

WORKDIR /app
COPY . /app
EXPOSE 3000

RUN curl -o- -L https://yarnpkg.com/install.sh | bash
RUN $HOME/.yarn/bin/yarn install


# Install dependencies
RUN yarn install

# Add jest global
RUN yarn global add jest nodemon

# ADD setup.sh /app
RUN ["chmod", "+x", "/app/setup.sh"]

# Avoid CRLF windows bug
RUN sed -i -e 's/\r$//' /app/setup.sh
ENTRYPOINT ["/app/setup.sh"]
