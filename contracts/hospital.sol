//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//Define the hospital contract 
contract Hospital{
    //Variable to store the administrator address
address public administrator;
//keeps traking of the hospital administration balance within the contract
uint public adminBalance;

//define the structure of the apoitments menu;
struct servicesMenu{

    string serviceName; // name of the service done by the hospital
    uint price;  //price for the service 
    string doctorName;
    uint date;
}
}