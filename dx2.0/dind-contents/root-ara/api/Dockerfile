FROM 666583083672.dkr.ecr.ap-northeast-2.amazonaws.com/newara:develop

WORKDIR /newara/www

RUN apt-get update && apt-get install netcat-openbsd supervisor gettext git vim less curl default-mysql-client htop nano zsh -y
RUN curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
RUN chsh -s `which zsh`

RUN pipenv install --dev
# RUN echo 'eval "$(pipenv shell)"' >> /root/.zshrc

# enable git into existing folder
RUN git clone -b develop https://github.com/sparcs-kaist/new-ara-api.git tmp_repo
RUN mv tmp_repo/.git .
RUN rm -rf tmp_repo
# remove inconsistancy btw git repo and api image
RUN git checkout -- .
# remove requirements.txt (it is for production)
RUN rm requirements.txt

RUN ln -s /newara/www /root/api
WORKDIR /root/api
