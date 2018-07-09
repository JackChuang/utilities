#! /bin/bash

ddone() {
	for i in `seq 5`; do echo; done
}

print_iter() {
	echo "############################"
	echo "############################"
	echo "$1"
	echo "############################"
	echo "############################"
}
	

while [ 1 ]; do
	let "iter++"
	print_iter $iter
	echo "testing kmeans"
#	./kmeans -c 10 -n 4 -t 8 -p 500000
	ddone

	echo "testing ft"
#	./ft.A.x 4 8
	ddone

	echo "testing cg"
#	./cg.A.x 4 8
	ddone
done
