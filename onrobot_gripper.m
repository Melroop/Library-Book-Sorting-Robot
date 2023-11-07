[gripperPub, gripperMsg] = rospublisher('/onrobot_rg2/joint_position_controller/command');
gripperMsg.Data = 0.2;
send(gripperPub,gripperMsg);