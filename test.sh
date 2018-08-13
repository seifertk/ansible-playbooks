#!/bin/sh

while getopts p:v: opt; do
    case $opt in
        p)
            PLAYBOOK="$OPTARG"
            ;;
        v)
            VAULT_PASSWORD_FILE="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
        ;;
    esac
done

if [ -z "$PLAYBOOK" ]; then
    PLAYBOOK='site.yml'
fi

if [ ! $(echo "$PLAYBOOK" | grep -i "\.yml" ) ]; then
    PLAYBOOK="$PLAYBOOK.yml"
fi

export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook -i stage -K "$PLAYBOOK"
