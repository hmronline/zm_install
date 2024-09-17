
##
## Run this on LXC Guest
##

### Important
# Make sure you have at least one camera with an event/recording
export ZM_EVENT_ID=11440
export ZM_MONITOR_ID=2

### Test
# replace www-data with apache if needed

# Make sure no errors are shown when training faces (if it fails, OpenCV is not working)
sudo -u www-data /var/lib/zmeventnotification/bin/zm_train_faces.py


sudo -u www-data /var/lib/zmeventnotification/bin/zm_event_start.sh ${ZM_EVENT_ID} ${ZM_MONITOR_ID}

# must show something like this
# [s] detected:person:98% car:97% --SPLIT--{"labels": ["person", "car", "car", "person", "car", "car", "car", "car", "car"], "boxes": [[22, 582, 296, 1126], [609, 314, 729, 386], [274, 312, 656, 590], [147, 512, 329, 972], [106, 306, 192, 372], [244, 293, 270, 319], [34, 354, 80, 394], [532, 310, 578, 364], [223, 289, 253, 317]], "frame_id": "snapshot", "confidences": [0.9785492420196533, 0.9729200601577759, 0.9687286615371704, 0.9296862483024597, 0.8647489547729492, 0.4630233645439148, 0.44988304376602173, 0.391483336687088, 0.32268357276916504], "image_dimensions": {"original": [1280, 720], "resized": [1422, 800]}}

sudo -u www-data /var/lib/zmeventnotification/bin/zm_detect.py --config /etc/zm/objectconfig.ini  --eventid ${ZM_EVENT_ID} --monitorid ${ZM_MONITOR_ID} --debug
