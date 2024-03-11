# 使用官方Python运行时作为父镜像
FROM python:3.8

# 设置工作目录为/app
WORKDIR /app

# 将当前目录内容复制到位于/app中的容器中
COPY . /app

# Install packages
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    software-properties-common \
    git \
    && rm -rf /var/lib/apt/lists/*
    
# 使用pip安装requirements.txt中列出的任何所需包
RUN pip install --no-cache-dir -r requirements.txt
