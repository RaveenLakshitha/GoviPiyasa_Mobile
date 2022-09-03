import * as React from 'react';
import { styled } from '@mui/material/styles';
import Paper from '@mui/material/Paper';
import Grid from '@mui/material/Grid';
import "./styles.css";
import AdminCard from '../../Components/AdminCard'; 
import experts from "./experts.png";
import designers from './designers.png';
import shop from './shop2.png';
import delivery from './delivery.png';
import item from './item.png';
import users from './users.png';
import admin1 from './admin1.jpg';
import { Card,CardBody,CardTitle,CardText,CardSubtitle,CardImg } from 'reactstrap';
import { useEffect,useState } from 'react';
import axios from "axios";
import { Typography, Avatar } from "@mui/material";


const Dashboard = () => {
  const [profile, setprofile] = useState()

  const [admin, setAdmin] = useState([]); 
  const user_token = window.localStorage.getItem("token");

  const url = 'https://charts.mongodb.com/charts-govi-piyasa-loirr';
  const [countries, setCountries] = useState([]);

  const [data1, setExpert] = useState([]);
  const [data2, setDelivery] = useState([]);
  const [data3, setArchitect] = useState([]);
  const getExpertCount = async () => {
    try {
      const data = await axios.get("https://mongoapi3.herokuapp.com/experts");
      setExpert(data.data.length);
    } catch (e) {
      console.log(e);
    }
  };
  const getDeliverCount = async () => {
    try {
      const data = await axios.get("https://mongoapi3.herokuapp.com/delivery");
      console.log(data.data.length);
      setDelivery(data.data.length);
    } catch (e) {
      console.log(e);
    }
  };
  const getArchitectCount = async () => {
    try {
      const data = await axios.get("https://mongoapi3.herokuapp.com/architect");
      console.log(data.data.length);
      setArchitect(data.data.length);
    } catch (e) {
      console.log(e);
    }
  };

  const getData = async () => {
    try{
      const data = await axios.get("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/auths/getLoggedUser",
                          { headers :  {'Authorization' : `Bearer ${user_token}`} });
                          console.log(data.data.data);
      setAdmin(data.data.data);
      console.log("users data:" ,data.data.data);
    }catch (e){
      console.log(e);
    }
  }

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
  getData();
  getExpertCount();
  getDeliverCount();
  getArchitectCount();

});
useEffect(() => {
  axios.get(url).then(res => {
    setCountries(res.data.countries);
    })
}, [])


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
                <img src={admin.profilePicture} className="image" sx={{width:'15px', height:'15px'}}/>
                <br></br>
              <div style={{backgroundColor:"#eeffe6" ,height: '150px'}}>
                
              <CardBody>
                <CardTitle tag="h3">{admin.userName}
                
                </CardTitle>
              <CardSubtitle
                className="mb-2 text-muted" tag="h5">
                  {admin.email}
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
           <AdminCard name="SHOPS" image={shop} data={data1} ></AdminCard> 
        </Grid>
        <Grid item xs={4}> <AdminCard name="ITEMS" image={item}>
        <Typography variant="h5" color="primary" align="center" textDecoration="none">
                  {/* Users {"\n"} */}
                  {data1}
                </Typography></AdminCard> </Grid>
        <Grid item xs={4}> <AdminCard name="USERS" image={users}></AdminCard> </Grid>
        <Grid item xs={4}> <AdminCard name="Experts" image={experts}></AdminCard> </Grid>
        <Grid item xs={4}> <AdminCard name="Deliver" image={delivery}></AdminCard> </Grid>
        <Grid item xs={4}> <AdminCard name="Designers" image={designers}></AdminCard> </Grid>
      </Grid>

    </Grid>

    <br></br>

    <Grid container spacing={3} columns={{ xs: 4, sm: 8, md: 12 }}>

      <Grid item container xs={6} columns={{ xs: 4, sm: 8, md: 12 }}>
        {/* <Grid item xs={12}>  
        
           </Grid> */}
           
      </Grid>
      <Chart height={'600px'} width={'800px'} filter={countries} chartId={'6311f01as-5a97-4808-867c-b63163948710'}/>
      <Grid item container xs={6} spacing={3} columns={{ xs: 4, sm: 8, md: 12 }}>
        <Grid item xs={12}> <Chart>Chart2</Chart> </Grid>
      </Grid>
      
    </Grid>
    </div>
  );

}
 
export default Dashboard;
