#!/bin/bash
# Scrubs the projec to sterilize it for a fresh start
#############################################################

GREEN='\033[0;32m' #green
YELLOW='\033[33m' #yellow
WHITE='\033[97m' #white
GRAY='\033[37m' #light gray
NC='\033[0m' #no-color
BOLD='\033[1m' #bold
BOLDEND='\033[0m' #bold end


TITLE="🧼 Scrubbed "
OPTIONS="${YELLOW}site${NC}, or ${YELLOW}purge${NC}"
OOPS="🚀💥🔥 OOPS! We need a valid option – Try using ${OPTIONS}"
MALFUNCTION="👨‍🚀 Huston... We have a problem! Make sure you use ${OPTIONS} - "

SITE="${WHITE}${BOLD}output${BOLDEND}${NC} & ${WHITE}${BOLD}all cache${BOLDEND}${NC} directories ✨"
FRESH="${WHITE}${BOLD}node_modules${BOLDEND}${NC}, ${WHITE}${BOLD}lock files${BOLDEND}${NC}, ${SITE}"

PURGE="🧹 ${GREEN}${BOLD}All Clean${BOLDEND}${NC} ✨ ${TITLE}${FRESH}${NC}\n\nRun ${YELLOW}${BOLD}bun/pnpm install${BOLDEND}${NC} to start fresh 🤩"

DEVFILES="dist/ _site/ .cache/ *.log"
NODEFILES="node_modules package-lock.json pnpm-lock.yaml yarn.lock .yarn/ bun.lockb deno.lock"

#################### DONT EDIT BELOW  👀 ####################
if [ $# -eq 0 ]
  then
    echo -e "$MALFUNCTION"
elif [ "$1" == "site" ]
  then
    (rm -rf ${DEVFILES} || del ${DEVFILES})
    echo -e ${TITLE}${SITE}
  elif [ "$1" == "purge" ]
    then
      (rm -rf ${DEVFILES} ${NODEFILES} || del ${DEVFILES} ${NODEFILES})
      echo -e ${PURGE}
  else
    echo -e "$OOPS"
fi
