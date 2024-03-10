# 使用官方Python运行时作为父镜像
FROM python:3.8

# 设置工作目录为/app
WORKDIR /app

# 将当前目录内容复制到位于/app中的容器中
COPY . /app

# 使用pip安装requirements.txt中列出的任何所需包
RUN pip install --no-cache-dir -r requirements.txt

# 使端口80可用于此容器外的环境
EXPOSE 80

# 定义环境变量（可选）
# ENV NAME GPT4DST

# 在容器启动时运行app.py
CMD ["python", "app.py"]