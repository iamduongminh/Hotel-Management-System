@echo off
echo Starting Refactor...
move /Y pages\staff\receptionist_dashboard.html pages\receptionist\dashboard.html
move /Y pages\staff\receptionist_room_management.html pages\receptionist\room_management.html
move /Y pages\staff\receptionist_shift.html pages\receptionist\shift.html
move /Y pages\staff\booking_form.html pages\receptionist\booking_form.html
move /Y pages\staff\booking_list.html pages\receptionist\booking_list.html
move /Y pages\staff\checkout.html pages\receptionist\checkout.html

move /Y pages\staff\housekeeper_dashboard.html pages\housekeeper\dashboard.html
move /Y pages\staff\housekeeping.html pages\housekeeper\cleaning_list.html
copy /Y pages\staff\room_management.html pages\housekeeper\room_management.html
copy /Y pages\staff\shift.html pages\housekeeper\shift.html

copy /Y pages\staff\room_management.html pages\manager\room_management.html
copy /Y pages\staff\shift.html pages\manager\shift.html

move /Y js\staff\receptionist_room_management.js js\receptionist\room_management.js
move /Y js\staff\receptionist_shift.js js\receptionist\shift.js
move /Y js\staff\booking_form.js js\receptionist\booking_form.js
move /Y js\staff\booking_list.js js\receptionist\booking_list.js
move /Y js\staff\checkout.js js\receptionist\checkout.js

move /Y js\staff\housekeeping.js js\housekeeper\cleaning_list.js
copy /Y js\staff\room_management.js js\housekeeper\room_management.js
copy /Y js\staff\shift.js js\housekeeper\shift.js

copy /Y js\staff\room_management.js js\manager\room_management.js
copy /Y js\staff\shift.js js\manager\shift.js

echo Done.
