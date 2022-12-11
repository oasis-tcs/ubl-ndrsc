#!/bin/bash

if [ "$3" = "" ]; then echo Missing results directory, platform, label ; exit 1 ; fi

export targetdir="$1"
export platform=$2
export label=$3

# Configuration parameters

export title="UBL 2.1"
export package=UBL-2.1
export UBLversion=2.1
export UBLstage=os
export UBLprevStageVersion=2.1
export UBLprevStage=
export UBLprevVersion=2.1
export rawdir=raw-2.1
export includeISO=false

bash build-common.sh "$1" "$2" "$3"

# Configuration parameters

export title="UBL 2.2"
export package=UBL-2.2
export UBLversion=2.2
export UBLstage=os
export UBLprevStageVersion=2.2
export UBLprevStage=
export UBLprevVersion=2.1
export rawdir=raw-2.2
export includeISO=false

bash build-common.sh "$1" "$2" "$3"

# Configuration parameters

export title="UBL 2.3"
export package=UBL-2.3
export UBLversion=2.3
export UBLstage=os
export UBLprevStageVersion=2.3
export UBLprevStage=
export UBLprevVersion=2.2
export rawdir=raw-2.3
export includeISO=false

bash build-common.sh "$1" "$2" "$3"

exit 0 # always be successful so that github returns ZIP of results
