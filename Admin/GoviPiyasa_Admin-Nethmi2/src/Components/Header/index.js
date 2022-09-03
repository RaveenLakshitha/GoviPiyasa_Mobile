import axios from "axios";
import React from "react";
import { useState , useEffect} from "react";
import { Link, useNavigate } from "react-router-dom";
import logo from "../logo.png";
import admin from "../admin.jpg";
import "./styles.css";
import NotificationsNoneIcon from '@mui/icons-material/NotificationsNone';
import Avatar from '@mui/material/Avatar';
import Menu from '@mui/material/Menu';
import MenuItem from '@mui/material/MenuItem';
import ListItemIcon from '@mui/material/ListItemIcon';
import Divider from '@mui/material/Divider';
import IconButton from '@mui/material/IconButton';
import InfoIcon from '@mui/icons-material/Info';
import Settings from '@mui/icons-material/Settings';
import Logout from '@mui/icons-material/Logout';



const Header = () => {

  const navigate = useNavigate();

  const user_token = window.localStorage.getItem("token");

  const [anchorEl, setAnchorEl] = useState(null);
  const open = Boolean(anchorEl);
  const [admin, setAdmin] = useState([]);

  const handleClick = (event) => {
    setAnchorEl(event.currentTarget);
  };
  const handleClose = () => {
    setAnchorEl(null);
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

  const signOutClick = async (event) => {
    event.preventDefault();

    try {
      const data = await axios.post("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/auths/signoutUser",
        { headers : 
          {'Authorization' : `Bearer ${user_token}`}
        }
      );
      console.log(data.data.token);
      localStorage.removeItem("token");
      console.log(window.localStorage.getItem("token"));
      navigate("/login");
    } catch (e) {
      console.log(e);
    }
  };
  useEffect(() => {
    getData();
  },[]);
  ////////////////////////////////////////

  ////////////////////////////////////////
  return (
    <div className="header">
      <div className="homeLogo">
        <Link to="/" className="link">
          <div>
           
          </div>
        </Link>
      </div>
      
      {/* <div style={{ marginRight: "10px"}}> */}
      <div>
        <IconButton>
         <NotificationsNoneIcon
            className="float-start" sx={{ color: 'black'}}
            onClick={() => {
              window.location.pathname = "/notification";
            }}
          />
          </IconButton>

          <IconButton
            onClick={handleClick} 
            aria-controls={open ? 'account-menu' : undefined} aria-haspopup="true"
            aria-expanded={open ? 'true' : undefined}
          >
            <Avatar src={admin.profilePicture}  sx={{width:'40px', height:'40px'}}>
            </Avatar>
          </IconButton>

          <Menu anchorEl={anchorEl} id="account-menu" open={open} onClose={handleClose} onClick={handleClose}

           PaperProps={{
              elevation: 0,
              sx: { overflow: 'visible', mt: 1.5,
                filter: 'drop-shadow(0px 2px 8px rgba(0,0,0,0.32))',
                '& .MuiAvatar-root': {
                  width: 30, height: 30, ml: -0.5, mr: 1,
                },
                '&:before': {
                  content: '""', display: 'block', position: 'absolute', top: 0, right: 14, width: 10, height: 10, 
                  bgcolor: 'background.paper', transform: 'translateY(-50%) rotate(45deg)', zIndex: 0,
                },
              },
            }}
            transformOrigin={{ horizontal: 'right', vertical: 'top' }}
            anchorOrigin={{ horizontal: 'right', vertical: 'bottom' }}
            >
              <Link to="/myProfile" style={{color: "black",textDecoration: 'none'}} >
                <MenuItem sx={{fontSize: 'small'}}> <Avatar /> Profile </MenuItem>
              </Link>

              <Divider />
              <MenuItem sx={{fontSize: 'small'}}> 
                <ListItemIcon> <Settings fontSize="small" /> </ListItemIcon> Settings 
              </MenuItem>

              <Link to="/about" style={{color: "black",textDecoration: 'none'}} >
              <MenuItem sx={{fontSize: 'small'}} > 
                <ListItemIcon> <InfoIcon fontSize="small" /> </ListItemIcon> About 
              </MenuItem>
              </Link>

              <Link to="/login" style={{color: "black", textDecoration: 'none'}}>
              <MenuItem sx={{fontSize: 'small'}} onClick={signOutClick}> 
                <ListItemIcon> <Logout fontSize="small" /> </ListItemIcon> Log out   
              </MenuItem>
              </Link>
            </Menu>

        {/* <ButtonGroup size="small" variant="contained" aria-label="outlined success button group" style={{padding:"5px"}}>
            <Button onClick={signOutClick}>
                <Link to="/login" style={{color: "white",textDecoration: 'none'}} >Sign out</Link>
            </Button>
            <Button>
                <Link to="/about" style={{color: "white",textDecoration: 'none'}} >About</Link>
            </Button>
        </ButtonGroup> */}

      </div>
    </div>
  );
};

export default Header;
