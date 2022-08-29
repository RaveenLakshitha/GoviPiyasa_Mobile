import * as React from 'react';
import { styled } from '@mui/material/styles';
import Paper from '@mui/material/Paper';
import Grid from '@mui/material/Grid';
import "./styles.css";
import AdminCard from '../../Components/AdminCard'; 
import ApexCharts from '../../Components/Chart';
import tiger from "./tiger.jpg";
import item1 from './item1.jpg';
import shop from './shop.jpg';
import item from './item.jpg';
import user from './user.png';
import admin from './admin.jpg';
import { Avatar } from '@material-ui/core';
import { Card,CardBody,CardTitle,CardText,CardSubtitle,CardImg } from 'reactstrap';
import { useEffect } from 'react';
import axios from "axios";
import { useState } from 'react';


const Dashboard = () => {
  const [profile, setprofile] = useState()

  const user_token = window.localStorage.getItem("token");

const getAllData = async () => {
  try {
    
    //console.log(window.localStorage.getItem("token"));
    // var config = {
    //   url:"https://govi-piyasa-v-0-1.herokuapp.com/api/v1/auths/getLoggedUser",
    //   headers:{ 'Authorization' : `Bearer ${user_token}`,
    //   }
    // }
    const data = await axios.get("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/auths/getLoggedUser",
              {headers : {
                'Authorization' : `Bearer ${user_token}`
              }})
    // console.log("***********");
    // console.log(user_token);
   
    // console.log(data);

    setprofile(data.data.data);
    // console.log(data.data.data);
  } catch (e) {
    console.log(e);
  }
};
useEffect(() => {
  getAllData();
});

  const Item = styled(Paper)(({ theme }) => ({
    backgroundColor: theme.palette.mode === 'dark' ? '#1A2027' : '#fff',
    ...theme.typography.body2,
    padding: theme.spacing(1),
    textAlign: 'center',
    height: '110px',
    color: theme.palette.text.secondary,
  }));

  const Admin = styled(Paper)(({ theme }) => ({
    backgroundColor: theme.palette.mode === 'dark' ? '#1A2027' : '#fff',
    ...theme.typography.body2,
    padding: theme.spacing(1),
    textAlign: 'center',
    height: '250px',
    color: theme.palette.text.secondary,
  }));

  const Chart = styled(Paper)(({ theme }) => ({
    backgroundColor: theme.palette.mode === 'dark' ? '#1A2027' : '#fff',
    ...theme.typography.body2,
    padding: theme.spacing(1),
    textAlign: 'center',
    height: '300px',
    color: theme.palette.text.secondary,
  }));



  return ( 
    
    <div className="content">
     

     <Grid container spacing={3} columns={{ xs: 4, sm: 8, md: 12 }}>

      <Grid item container xs={4} columns={{ xs: 4, sm: 8, md: 12 }}>
        <Grid item xs={12}>
              {/* <Admin> */}

          <div>
          <Card body
              className="text-center"
              // style={{width: '25rem', height: '20rem' }}
              >
                <img src={admin} className="image" sx={{width:'15px', height:'15px'}}/>
                <br></br>
              <div style={{backgroundColor:"#B6C4A9" ,height: '150px'}}>
                
              <CardBody>
                <CardTitle tag="h5"> Rageesha
                  {/* {profile.userName} */}
                </CardTitle>
              <CardSubtitle
                className="mb-2 text-muted" tag="h6">
                  {/* {profile.email} */} sajinirageesha@gmail.com
              </CardSubtitle>
            </CardBody>
            </div>
          </Card>
          </div>
              {/* </Admin> */}
        </Grid>
      </Grid>

      <Grid item container xs={8} spacing={3} columns={{ xs: 4, sm: 8, md: 12 }}>
        <Grid item xs={4}>
           <AdminCard name="SHOPS" image={shop}></AdminCard> 
        </Grid>
        <Grid item xs={4}> <AdminCard name="ITEMS" image={item1}></AdminCard> </Grid>
        <Grid item xs={4}> <AdminCard name="USERS" image={user}></AdminCard> </Grid>
        <Grid item xs={4}> <AdminCard name="Experts" image={tiger}></AdminCard> </Grid>
        <Grid item xs={4}> <AdminCard name="Deliver" image={shop}></AdminCard> </Grid>
        <Grid item xs={4}> <AdminCard name="Designers" image={item}></AdminCard> </Grid>
      </Grid>

    </Grid>

    <br></br>

    <Grid container spacing={3} columns={{ xs: 4, sm: 8, md: 12 }}>

      <Grid item container xs={6} columns={{ xs: 4, sm: 8, md: 12 }}>
        <Grid item xs={12}> <Chart>  </Chart> </Grid>
      </Grid>

      <Grid item container xs={6} spacing={3} columns={{ xs: 4, sm: 8, md: 12 }}>
        <Grid item xs={12}> <Chart>Chart2</Chart> </Grid>
      </Grid>
      
    </Grid>
    </div>
  );

}
 
export default Dashboard;
