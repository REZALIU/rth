FROM python:3.9-slim

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY requirements.txt .
COPY main.py .

# 创建archive目录
RUN mkdir archive

# 安装依赖
RUN pip install -r requirements.txt

# 安装cron
RUN apt-get update && apt-get install -y cron

# 添加crontab配置
RUN echo "*/10 * * * * cd /app && python main.py >> /var/log/cron.log 2>&1" > /etc/cron.d/app-cron
RUN chmod 0644 /etc/cron.d/app-cron
RUN crontab /etc/cron.d/app-cron

# 创建日志文件
RUN touch /var/log/cron.log

# 启动命令
CMD cron && tail -f /var/log/cron.log