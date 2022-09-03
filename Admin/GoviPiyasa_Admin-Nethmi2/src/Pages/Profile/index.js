import { height, width } from "@mui/system";
import React from "react";
import img1 from '../../Images/admin.jpg';
import img2 from '../../Images/prof.jpg';
import EditAdmin from "../../Components/EditAdmin";
import "./styles.css";
import { styled } from '@mui/material/styles';
import Paper from '@mui/material/Paper';
import Grid from '@mui/material/Grid';
import Box from '@mui/material/Box';
import ListItemText from '@mui/material/ListItemText';
import ListItemButton from '@mui/material/ListItemButton';
import DraftsIcon from '@mui/icons-material/Drafts';
import Button from '@mui/material/Button';
import axios from "axios";
import { useState, useEffect } from "react";
import AddIcCallIcon from '@mui/icons-material/AddIcCall';
import PersonIcon from '@mui/icons-material/Person';
import LocationCityIcon from '@mui/icons-material/LocationCity';

const Item = styled(Paper)(({ theme }) => ({
  backgroundColor: theme.palette.mode === 'dark' ? '#1A2027' : '#fff',
  ...theme.typography.body2,
  padding: theme.spacing(1),
  textAlign: 'center',
  color: theme.palette.text.secondary,
}));

const Profile = () => {

  const [admin, setAdmin] = useState([]);
  const user_token = window.localStorage.getItem("token");
  const handleClose = () => setShow(false);
  const handleShow = () => setShow(true);
  const [show, setShow] = useState(false);

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

  useEffect(() => {
    getData();
  },[]);

  return (
    <div className="content" backgroundImage="prof.jpg" >

      <div className="pro">
      <Box sx={{ flexGrow: 1 }}>
      <Grid container spacing={2} sx={{backgroundImage : img2}}>
        <Grid  item xs={6} md={4} sx={{backgroundImage : img2}}>
          {/* <Item sx={{height:"160px", width:"250px"}}>
         */}
            <img src={admin.profilePicture}  className="img" />
        {/* <div className="child"> */}
          {/* </div> */}
          {/* </Item> */}
        </Grid>
        <Grid sx={{ display:"flex", alignItems:"center",justifyContent:"left", direction:"column", fontFamily:"initial", fontSize:'2rem', color:"green"}} item xs={6} md={8} >
          {/* <Item sx={{height:"100px", width:"450px" , backgroundColor:"ButtonShadow"}} >   */}
          {admin.userName}
              <Item sx={{display:"flex", margin: '0 auto'}}>
                    <Button variant="contained" color="success" onClick={handleShow}> EDIT
                  </Button>
                  <EditAdmin show={show} handleClose={handleClose} />
          
              </Item>
          {/* </Item> */}
          
        </Grid>
        <Grid sx={{ display:"flex", alignItems:"center" }}item xs={8} md={4}>
        <Grid item xs={4} md={6} sx={{ paddingLeft:"40px", paddingRight:"10px"}}>
                  <Item sx={{ width:"180px"} }>

                    <ListItemButton>
                      <PersonIcon/>
                      <ListItemText primary="Name" />
                    </ListItemButton>

                    <ListItemButton>
                      <DraftsIcon style={{padding:"right"}} />{" "}
                      <ListItemText primary="Email" />
                    </ListItemButton>

                    <ListItemButton>
                      <AddIcCallIcon/>
                      <ListItemText primary="Contact No" />
                    </ListItemButton>

                    <ListItemButton>
                      <LocationCityIcon/>
                      <ListItemText primary="City" />
                    </ListItemButton>

                  </Item>
                </Grid>
    
        </Grid>
        <Grid container spacing={2}item xs={6} md={8} >
          
                <Grid item xs={6} md={8}>
                  <Item>

                    <ListItemButton>
                     <ListItemText primary={admin.userName} />
                    </ListItemButton>

                      
                    <ListItemButton>
                      <ListItemText primary={admin.email} />
                    </ListItemButton>

                      
                    <ListItemButton>
                    <ListItemText primary={admin.contactNumber} />
                    </ListItemButton>

                    <ListItemButton>
                      <ListItemText primary={admin.city}/>
                    </ListItemButton>

                  
                  </Item>
                </Grid>
          {/* </Item> */}
        </Grid>
      </Grid>
    </Box>
    </div>
      {/* <div className="pro">
      <form method="">
      <div className="row">
        <div className="col-md-4">
          <div className="child">
            <img src={img}  style={{width:'100px' , height:'100px'}} alt="" />

          </div>
          
        </div>
      </div>

     </form>
      </div> */}
     
    </div>
  );
}
 
export default Profile;