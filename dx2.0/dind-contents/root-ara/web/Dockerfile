FROM 666583083672.dkr.ecr.ap-northeast-2.amazonaws.com/newara-front:dev

WORKDIR /usr/share/nginx/newara

# Dirty solution, but works well?
RUN find . -type f -exec sed -i "s#https://newara.dev.sparcs.org#https://REPLACEMENT_NICKNAME.newaradx.sparcs.org#g" {} +