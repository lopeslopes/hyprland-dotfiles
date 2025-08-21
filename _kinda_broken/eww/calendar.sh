#!/bin/bash

# Get current date info
today_day=$(date +%-d)
today_month=$(date +%B)
first_day_of_month=$(date +%Y-%m-01)

# Get month length (last day of month)
monthlength=$(date -d "$first_day_of_month +1 month -1 day" +%-d)

# Get first weekday (0 = Sunday, ..., 6 = Saturday)
first_weekday=$(date -d "$first_day_of_month" +%w)

# Generate actual days with optional "currentday" class
declare -a days=()
for ((i=1; i<=monthlength; i++)); do
    if [ $i -eq $today_day ]; then
        days+=("${i}\" :class \"currentday\"")
    else
        days+=("${i}\"")
    fi
done

# Generate front padding
for ((i=0; i<first_weekday; i++)); do
    days=("\"\" :class \"invalidday\"" "${days[@]}")
done

# Generate end padding to make total 42 cells (6 weeks)
total_cells=42
while [ ${#days[@]} -lt $total_cells ]; do
    days+=("\"\" :class \"invalidday\"")
done

# Generate calendar layout in eww literal format
eww update calendarliteral="(box :orientation \"v\" :space-evenly \"false\" :spacing 20 \
  (box :class \"daynames\" :orientation \"h\" :space-evenly \"false\" :spacing 35 :halign \"center\" \
    (label :text \"Su\")(label :text \"Mo\")(label :text \"Tu\")(label :text \"We\")(label :text \"Th\")(label :text \"Fr\")(label :text \"Sa\") \
  ) \
  (box :class \"calendardays\" :orientation \"v\" :spacing 40 :halign \"center\" \
    $(for ((week=0; week<6; week++)); do
        echo -n "(box :space-evenly \"true\" :orientation \"h\" :halign \"center\" :spacing 36 "
        for ((day=0; day<7; day++)); do
            idx=$((week * 7 + day))
            echo -n "(label :text \"${days[$idx]})"
        done
        echo ")"
      done)
  ) \
)"
