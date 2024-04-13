# http://stackoverflow.com/a/16553351
# get length of an array
nrOfProjects=${#projects[@]}
urgencyPrio=4

#echo "Setting up TaskWarrior and TimeWarrior with ${nrOfProjects} projects..."
#echo "DONE = $DONE / URGENT = $URGENT / OVERDUE = $OVERDUE / DUETODAY = $DUETODAY  / DUETOMORROW = $DUETOMORROW"

# Loop will set up task next, task add, task log and timew start for all projects listed above
for (( i = 0; i < $nrOfProjects; i++ ));
do
  #echo "Project $i = ${projects[i]}"
  #alias tn$i="task next project:${projects[i]} +READY"
  #alias tnu$i="tn${i} urgency \> ${urgencyPrio}"
  alias ta$i="task add project:${projects[i]}"
  #alias tl$i="task log project:${projects[i]}"
  #alias twst$i="timew start ${projects[i]}"
done;
