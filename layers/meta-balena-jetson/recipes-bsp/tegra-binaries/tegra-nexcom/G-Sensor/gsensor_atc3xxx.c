/*	For LSM6DSL 3-axis accelerometer and gyroscope	*/

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>		//open
#include <unistd.h>		//read,write
#include <sys/ioctl.h>	//ioctl
#include <linux/i2c-dev.h>	//i2c
#include <signal.h>		//signal
#include <string.h>


#define I2C_DEV_ADDR 0x6B		  	 		 // G sensor address is 0x6b

/*Global variables*/
int fd_i2c;
int loop_flag;
//int SLP_SECS = 3; //default value
char I2C_FILE_NAME[12] = "/dev/i2c-7";  // G sensor device on I2C BUS 7

int open_i2c(char *i2c_bus, char address);	//Open device on i2c bus
int write_i2c(int fd, char *buf, int len);	//Write
int read_i2c(int fd, char *buf, int len);	//Read
int read_ACC_value(int fd, double *X, double *Y, double *Z);	//Read accelerometer Value
int read_GYRO_value(int fd, int *X, int *Y, int *Z);	//Read gyroscope Value
int init_LSM6DSL(int fd);	//initialize LSM6DSL
int shut_LSM6DSL(int fd);	//shut down LSM6DSL

int open_i2c(char *i2c_bus, char address){
	int fd = 0;
	if( (fd = open(i2c_bus, O_RDWR)) < 0) {
		printf("Failed to open %s\n", i2c_bus);
		return -1;
	}
	if( ioctl(fd, I2C_SLAVE_FORCE, address) < 0 ){
		printf("Failed to acquire bus access and/or talk to slave.\n");
		return -1;
	}
	return fd;
}

int write_i2c(int fd, char *buf, int len){
//	buf[0] = reg;	//register to be accessed
//	buf[1] = 0x??;	//Data to be written
//	buf[2] = 0x??;	//Data to be written

	if ( write(fd, buf, len) != len ) {
		/* ERROR HANDLING: i2c transaction failed */
		printf("I2C write error\n");
		return -1;
	}
	return 0;
}

int read_i2c(int fd, char *buf, int len){
	if ( read(fd, buf, len) != len ) {	// ERROR HANDLING: i2c transaction failed
		printf("I2C read error\n");
		return -1;
	} else 	// buf[0] contains the read byte
		return 0;
}

int read_ACC_value(int fd, double *X, double *Y, double *Z){
	double x=0, y=0, z=0;
	int r_res=0, w_res=0;
	char buff[8]={0x00};

	char Reg = 0x28;	//The starting register of accelerometer data
	w_res = write_i2c(fd, &Reg, 1);
	if( w_res < 0){
		printf("[Error] Can't moving Register\n");
	}
	r_res = read_i2c(fd, buff, 6);	//read 6 bytes contain values
	if( r_res <0 ){
		printf("[Error] Can't read X,Y,Z axis value\n");
		return -1;
	}else{
		x = (buff[1]<<8) + buff[0];
		y = (buff[3]<<8) + buff[2];
		z = (buff[5]<<8) + buff[4];
		if ( x > 32767) x -= 65536;
		if ( y > 32767) y -= 65536;
		if ( z > 32767) z -= 65536;
		x /= 16393;
		y /= 16393;
		z /= 16393;
		*X = x;
		*Y = y;
		*Z = z;
		return 0;
	}
}

int read_GYRO_value(int fd, int *X, int *Y, int *Z){
	int r_res=0, w_res=0;
	char buff[8]={0x00};
	
	char Reg = 0x22;	//The starting register of gyroscope data
	w_res = write_i2c(fd, &Reg, 1);
	if( w_res < 0){
		printf("[Error] Can't moving Register\n");
	}
	r_res = read_i2c(fd, buff, 6);	//read 6 bytes contain values
	if( r_res <0 ){
		printf("[Error] Can't read X,Y,Z axis value\n");
		return -1;
	}else{
		*X = (buff[1]<<8) + buff[0];
		*Y = (buff[3]<<8) + buff[2];
		*Z = (buff[5]<<8) + buff[4];
		return 0;
	}
}

int init_LSM6DSL(int fd){
	char Buf[2] = {0x00};
	int w_res = 0;
	
	Buf[0] = 0x10;	//Reg CTRL1_XL for accelerometer
	Buf[1] = 0x60;	//Val 416Hz (High performance)
	w_res += write_i2c(fd, Buf, 2);
	
	Buf[0] = 0x11;	//Reg CTRL2_G for gyroscope
	Buf[1] = 0x60;	//Val 416Hz (High performance)
	w_res += write_i2c(fd, Buf, 2);
	
	Buf[0] = 0x0D;	//Reg INT1_CTRL
	Buf[1] = 0x01;	//Val
	w_res += write_i2c(fd, Buf, 2);
	
	if( w_res != 0)
	{
		printf("Initalize LSM6DSL failed\n");
		return -1;
	}
	printf("Initalize LSM6DSL successfully\n");
	return 0;
}
int shut_LSM6DSL(int fd){
	char Buf[2] = {0x00};
	int w_res = 0;
	Buf[0] = 0x10;	//Reg CTRL1_XL for accelerometer
	Buf[1] = 0x00;	//Val
	w_res += write_i2c(fd, Buf, 2);
	
	Buf[0] = 0x11;	//Reg CTRL2_G for gyroscope
	Buf[1] = 0x00;	//Val
	w_res += write_i2c(fd, Buf, 2);
	
	Buf[0] = 0x0D;	//Reg INT1_CTRL
	Buf[1] = 0x00;	//Val
	w_res += write_i2c(fd, Buf, 2);
	
	if( w_res != 0)
	{
		printf("Shut down LSM6DSL failed\n");
		return -1;
	}
	printf("Shut down LSM6DSL successfully\n");
	return 0;
}

/*
void read_ADXL345_IRQ(int fd){
	char Reg=0x30;
	char Buf;
	write_i2c(fd, &Reg, 1); //move to Register 0x30
	read_i2c(fd, &Buf, 1);	//read Register 0x30
//	printf("Read Buf: %02X\n",Buf);
	if( (Buf>>5) &0x01 )
		printf("Double tap interrupt occured!\n");
	else if( (Buf>>6) &0x01 )
		printf("Single tap interrupt occured!\n");
} 

void IRQ_handler(int sig){
	//read Reg 0x30
	read_ADXL345_IRQ(fd_i2c);
}
*/

//Parameter 1: temp file name
int main(int argc , char *argv[]){
	int i;
	if (argc == 3 )	{
		i = atoi(argv[2]);
		sprintf(I2C_FILE_NAME + strlen(I2C_FILE_NAME) - 1,"%s",argv[2]);
	}
	else {
		printf("Help 	: ./gsensor argv[1] argv[2]\n");
		printf("argv[1] : save output as file.\n");
		printf("argv[2] : i2c Bus(Only i2c bus number)\n");
		printf("e.g.	: ./gsensor ./tmp.log 0\n");
		return -1;
	}
	printf("%s\n",I2C_FILE_NAME);
	char string[64]={0x00};
	FILE *fd_tmp = fopen(argv[1], "w");
	if( fd_tmp == NULL ){
		printf("Unable to create %s", argv[1]);
		return -1;
	}
	//SLP_SECS = atoi(argv[2]);
	//printf("%s\n",argv[2]);
	fd_i2c = open_i2c(I2C_FILE_NAME, I2C_DEV_ADDR);
    if( fd_i2c < 0 ){
        printf("open %s failed", I2C_FILE_NAME);
        return -1;
    }
	fd_i2c = open_i2c(I2C_FILE_NAME, I2C_DEV_ADDR);
    if( fd_i2c < 0 ){
        printf("open %s failed", I2C_FILE_NAME);
        return -1;
    }

	//initialize G sensor
	init_LSM6DSL(fd_i2c);
	sleep(1);

	double ACC_X_start=0, ACC_Y_start=0, ACC_Z_start=0;
	double ACC_X_end=0, ACC_Y_end=0, ACC_Z_end=0;
	int GYRO_X_start=0, GYRO_Y_start=0, GYRO_Z_start=0;
	int GYRO_X_end=0, GYRO_Y_end=0, GYRO_Z_end=0;

	//read X,Y,Z axis value	
	read_ACC_value(fd_i2c, &ACC_X_start, &ACC_Y_start, &ACC_Z_start);
	read_GYRO_value(fd_i2c, &GYRO_X_start, &GYRO_Y_start, &GYRO_Z_start);
	printf("ACC X:%.2fG\tY:%.2fG\tZ:%.2fG\n", ACC_X_start, ACC_Y_start, ACC_Z_start);
	printf("GYRO X:%X\tY:%X\tZ:%X\n", GYRO_X_start, GYRO_Y_start, GYRO_Z_start);
	printf("Left the machine for 3 seconds...\n");
	sleep(3);

	//read X,Y,Z axis value
	read_ACC_value(fd_i2c, &ACC_X_end, &ACC_Y_end, &ACC_Z_end);
	read_GYRO_value(fd_i2c, &GYRO_X_end, &GYRO_Y_end, &GYRO_Z_end);
	printf("ACC X:%.2fG\tY:%.2fG\tZ:%.2fG\n", ACC_X_end, ACC_Y_end, ACC_Z_end);
	printf("GYRO X:%X\tY:%X\tZ:%X\n", GYRO_X_end, GYRO_Y_end, GYRO_Z_end);
	
	sprintf(string, "%.2f,%.2f\n%.2f,%.2f\n%.2f,%.2f\n", ACC_X_start, ACC_X_end, ACC_Y_start, ACC_Y_end, ACC_Z_start, ACC_Z_end);
	fputs(string, fd_tmp);
	
	shut_LSM6DSL(fd_i2c);
	close(fd_i2c);
	fclose(fd_tmp);	
	return 0;
}
