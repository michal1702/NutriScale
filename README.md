# Nutri Scale
BSc project involving the creation of a kitchen scale with a dedicated mobile application.

## Design assumptions
### Scale

 - Possibility to weigh food products with a maximum weight of 5 kg
 - A screen that allows you to display the current load, as well as informing about exceeding the limit of 5 kilograms
 - Button for changing the units of mass: grams, ounces
 - Weight reset button (tare)
 - A wireless network module that allows you to connect to a mobile application
 - Diode symbolizing connection to a wireless network
 - Rechargeable battery powered 

### Mobile app

 - A mobile application for an Android phone
 - The ability to create an account and log in
 - Favorite products section
 - Statistics on the consumed macronutrients in numerical form and in the form of charts
 - Proposals for supplementing caloric deficiencies
 - Notifications to remind you to eat regularly

## Technologies and components

### Mobile app
 - Flutter - the main platform used to create a mobile application
 - Firebase - database platform
 - SpoonacularAPI - API used to retrieve food information

### Scale
 - ESP-32 Lite microcontroller with Bluetooth 4.2 Low Energy module
 - 2x YZC-131 strain gauges with a maximum load of 5 kg
 - HX711 strain gauge beam amplifier
 - 1.77 '' LCD TFT display
 - 1350 mAh lithium-polymer Akyga battery
 - Buttons, LED

## Images
A few photos presenting the work done
### App
<nobr><img src="https://user-images.githubusercontent.com/34627723/153942473-d19f30fc-6c54-4f3d-8ba1-ea5dd9c2658a.jpg" alt="img8" width="220"/></nobr>
<nobr><img src="https://user-images.githubusercontent.com/34627723/153942479-46ee7f3a-10cd-4ffc-83c0-fb93f7629501.jpg" alt="img9" width="220"/></nobr>
<nobr><img src="https://user-images.githubusercontent.com/34627723/153942437-6939bd26-b5f6-4ca8-af09-d56e57f08a81.jpg" alt="img1" width="220"/></nobr>
<nobr><img src="https://user-images.githubusercontent.com/34627723/153942442-8cfb0e2c-158f-44c0-9deb-a028c0a0e3b8.jpg" alt="img2" width="220"/></nobr>
<nobr><img src="https://user-images.githubusercontent.com/34627723/153942447-c44b07c5-8c45-4dff-96f6-2a6180bb5f9a.jpg" alt="img3" width="220"/></nobr>
<nobr><img src="https://user-images.githubusercontent.com/34627723/153942453-8f4d2105-3ae7-4ced-95fb-c4f0028391e9.jpg" alt="img4" width="220"/></nobr>
<nobr><img src="https://user-images.githubusercontent.com/34627723/153942460-cf128f08-eee1-4f34-b086-bccab7a0389f.jpg" alt="img5" width="220"/></nobr>
<nobr><img src="https://user-images.githubusercontent.com/34627723/153942463-79a70291-1311-4ac7-ad7b-e645c0591ce5.jpg" alt="img6" width="220"/></nobr>
<nobr><img src="https://user-images.githubusercontent.com/34627723/153942467-cb0a4853-0a06-4309-9528-b86cd05b0c8c.jpg" alt="img7" width="220"/></nobr>



### Scale
<nobr><img src="https://user-images.githubusercontent.com/34627723/153941416-a2c0caa9-7ac5-4ca9-94bf-550efa8ed83f.jpg" alt="img10" width="400"/></nobr>
<img src="https://user-images.githubusercontent.com/34627723/153941913-9a908522-0b16-4e57-ae0b-16f05b1068b0.JPG" alt="img11" width="600"/>
