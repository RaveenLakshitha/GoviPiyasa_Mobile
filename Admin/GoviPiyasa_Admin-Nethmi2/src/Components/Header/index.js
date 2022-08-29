import axios from "axios";
import React from "react";
import { useState } from "react";
import { Link, useNavigate } from "react-router-dom";
import logo from "../logo.png";
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

  const handleClick = (event) => {
    setAnchorEl(event.currentTarget);
  };
  const handleClose = () => {
    setAnchorEl(null);
  };


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

  ////////////////////////////////////////

  ////////////////////////////////////////
  return (
    <div className="header">
      <div className="homeLogo">
        <Link to="/" className="link">
          <div>
            <div className="image">
              <img src={logo} height="50" alt="" />
            </div>
          </div>
        </Link>
      </div>
      
      {/* <div style={{ marginRight: "10px"}}> */}
      <div>
        <IconButton>
         <NotificationsNoneIcon
            className="float-start" sx={{ color: 'white'}}
            onClick={() => {
              window.location.pathname = "/notification";
            }}
          />
          </IconButton>
        {/* <div className="barButtons">
          <Link to="/login" className="link">
            <li className="sideBarList">
              <div id="title">Log in</div>
            </li>
          </Link>
          <button className="float-start m-3" onClick={signOutClick}>
            Sign Out
          </button>
          <Link to="/about" className="link">
            <li className="sideBarList">
              <div id="title">About</div>
            </li>
          </Link>
        </div> */}

          <IconButton
            onClick={handleClick} 
            aria-controls={open ? 'account-menu' : undefined} aria-haspopup="true"
            aria-expanded={open ? 'true' : undefined}
          >
            <Avatar sx={{ width: 40, height: 40 }}>M</Avatar>
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
