FROM ubuntu:22.04

WORKDIR /src

COPY ./entrypoint.sh \
       ./lowcode-demo-for-preview.patch \
       ./lowcode-demo-for-edit.patch \
       ./lowcode-demo-https.patch \
       ./logo.png \
       ./

COPY ./crt ./crt

# 旧的安装方式：curl -sL https://deb.nodesource.com/setup_18.x | bash -;

# 安装nodejs 参考：https://github.com/nodesource/distributions

# 换源
RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN apt update || apt update
RUN apt install -y wget git vim jq ca-certificates curl gnupg || apt install -y wget git vim jq ca-certificates curl gnupg

RUN mkdir -p /etc/apt/keyrings && \
      curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
      export NODE_MAJOR=20 && \
      echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

RUN apt update && \
      apt install -y nodejs && \
      npm install -g yarn

RUN git clone --branch v1.3.19 https://github.com/alibaba/lowcode-demo.git

# 如果是 lowcode-demo 那么就能看到所有用例
ENV PROJ_PATH=/src/lowcode-demo/demo-general
ENV PREVIEW_PATH=/src/lowcode-demo/demo-general-preview-only

# 安装raw-loader用于加载本地文件
# 配置文件统一放在容器内部的 /src/pro/ 路径下
RUN cd lowcode-demo && \
      git apply -p1 < /src/lowcode-demo-for-edit.patch && \
      git apply -p1 < /src/lowcode-demo-https.patch && \
      cp -a /src/crt/* "${PROJ_PATH}" && \
      cp -a "${PROJ_PATH}" "${PREVIEW_PATH}" && \
      git apply -p1 < /src/lowcode-demo-for-preview.patch

# PS: 之前阿里员工管理的时候把yarn.lock也传上去了。里面使用的是阿里内部的源地址。。。
# RUN rm -rf "${PROJ_PATH}/yarn.lock" "${PREVIEW_PATH}/yarn.lock"

RUN cd "${PROJ_PATH}" && \
      yarn && \
      yarn add -D raw-loader && \
      cd "${PREVIEW_PATH}" && \
      yarn && \
      yarn add -D raw-loader && \
      mv /src/logo.png "${PREVIEW_PATH}/public/"

ENTRYPOINT [ "bash", "/src/entrypoint.sh" ]
