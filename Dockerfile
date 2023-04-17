FROM node:alpine
RUN apk add --no-cache git
ARG gitPath="/app/anikatsu-api"
WORKDIR /app
RUN git clone https://github.com/shashankktiwariii/anikatsu-api.git
WORKDIR $gitPath
RUN npm install
EXPOSE 3000
RUN tee /home/gitPull.sh > /dev/null <<EOF
cronLog='/home/cron.log'
echo \`date +'%Y-%m-%d %H:%M:%S'\`" ::: Git Pull START" >> \$cronLog
git -C $gitPath fetch --quiet
git -C $gitPath remote prune origin
git -C $gitPath checkout -f --quiet
git -C $gitPath pull -f --quiet
success=\$?
if [ \$success -eq 0 ]; then
    echo \`date +'%Y-%m-%d %H:%M:%S'\`" ::: Git Pull END" >> \$cronLog
    nginx -s reload
    echo \`date +'%Y-%m-%d %H:%M:%S'\`" ::: Nginx Reloaded" >> \$cronLog
else
    echo \`date +'%Y-%m-%d %H:%M:%S'\`" ::: Git Pull FAILED" >> \$cronLog
fi
EOF
# Bug with tee command above adding carriage-return ^M character at end of each line
RUN sed -i 's/\r$//' /home/gitPull.sh
RUN chmod +x /home/gitPull.sh
RUN echo '0 */6 * * * /home/gitPull.sh >/dev/null 2>&1' >> /etc/crontabs/root
CMD crond && npm start
