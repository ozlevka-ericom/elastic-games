# Create with disk for build
gcloud compute --project "ozlevka" instances create "docker-test" --zone "us-east4-c" --machine-type "n1-standard-4" --network "default" \
      --metadata "startup-script=mkdir -p /home/ozlevka/mydisk && chown ozlevka:ozlevka /home/ozlevka/mydisk && mount -t ext4 /dev/sdb1 /home/ozlevka/mydisk && exec /home/ozlevka/mydisk/meetup/install-docker" \
      --no-restart-on-failure --maintenance-policy "TERMINATE" --preemptible --service-account "228176938798-compute@developer.gserviceaccount.com" \
       --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
       --disk "name=docker-disk,device-name=docker-disk,mode=rw,boot=no" --image "ubuntu-1604-xenial-v20171002" --image-project "ubuntu-os-cloud" \
       --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "docker-test"



#Docker machine 17.09 overlay
gcloud compute --project "ozlevka" instances create "docker-cluster" --zone "us-east4-c" --machine-type "n1-standard-2" --network "default" --metadata "startup-script=bash <(curl -s https://raw.githubusercontent.com/ozlevka/elastic-meetup/master/install-docker-17.09.sh)" --no-restart-on-failure --maintenance-policy "TERMINATE" --preemptible --service-account "228176938798-compute@developer.gserviceaccount.com" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --image "ubuntu-1604-xenial-v20171002" --image-project "ubuntu-os-cloud" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "docker-cluster"

#Docker machine 17.06 aufs
gcloud compute --project "ozlevka" instances create "docker-cluster" --zone "us-east4-c" --machine-type "n1-standard-2" --network "default" --metadata "startup-script=bash <(curl -s https://raw.githubusercontent.com/ozlevka/elastic-meetup/master/install-docker-17.06.sh)" --no-restart-on-failure --maintenance-policy "TERMINATE" --preemptible --service-account "228176938798-compute@developer.gserviceaccount.com" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --image "ubuntu-1604-xenial-v20171002" --image-project "ubuntu-os-cloud" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "docker-cluster"


#Docker 17.09 and elastic bootstrap reqs
gcloud compute --project "ozlevka" instances create "docker-cluster" --zone "us-east4-c" --machine-type "n1-standard-2" --network "default" --metadata "startup-script=bash <(curl -s https://raw.githubusercontent.com/ozlevka/elastic-meetup/master/install-docker-17.09.sh) && sysctl -w vm.max_map_count=262144" --no-restart-on-failure --maintenance-policy "TERMINATE" --preemptible --service-account "228176938798-compute@developer.gserviceaccount.com" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring.write","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --image "ubuntu-1604-xenial-v20171002" --image-project "ubuntu-os-cloud" --boot-disk-size "10" --boot-disk-type "pd-standard" --boot-disk-device-name "docker-cluster"

