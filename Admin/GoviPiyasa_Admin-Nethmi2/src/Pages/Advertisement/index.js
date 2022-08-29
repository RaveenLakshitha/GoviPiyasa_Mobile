import * as React from 'react';
import axios from "axios";
import img1 from "../../Images/bgImage1.png"
import {Card, Box} from '@mui/material';
import { IconButton } from "@mui/material";
import CardActions from '@mui/material/CardActions';
import CardContent from '@mui/material/CardContent';
import CardMedia from '@mui/material/CardMedia';
import TextField from '@mui/material/TextField';
import ClearIcon from '@mui/icons-material/Clear';
import SearchIcon from '@mui/icons-material/Search';
import Button from '@mui/material/Button';
import Typography from '@mui/material/Typography';
import { useState, useEffect } from 'react';

const Advertisement = () => {

  const [ads, setAds] = useState([]);
  const [platform, setPlatform] = useState([]);
  const [searchText, setSearchText] = useState('');

  const getData = async () => {
    try {
      const data = await axios.get("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/advertisements");
      setAds(data.data.data);
      setPlatform(data.data.data);
    } catch (e) {
      console.log(e);
    }
  };

  useEffect(()=>{
    getData();
  },[])


  //search function
  function escapeRegExp(value) {
    return value.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&');
  }
  const requestSearch = (searchValue) => {
    const searchRegex = new RegExp(escapeRegExp(searchValue), 'i');
    const filteredRows = platform.filter((row) => {
      
        return searchRegex.test(row.userName);
    });
    setAds(filteredRows);
  };

  

  return (
    <div className="content">

      <Box>
        <TextField variant="standard" value={searchText}
          onChange={(e) => { setSearchText(e.target.value); requestSearch(e.target.value) }}
          placeholder="Search..."
            InputProps={{
              startAdornment: <SearchIcon fontSize="small" color="action" />,
              endAdornment: (
                <IconButton title="Clear" aria-label="Clear" size="small"
                  style={{ visibility: searchText ? 'visible' : 'hidden', borderRadius: "57%", paddingRight: "1px", margin: "0", fontSize: "1.25rem" }}
                  onClick={(e) => {setSearchText(''); setAds(platform)} }
                >
                  <ClearIcon fontSize="small" color="action" />
                </IconButton>
              ),
            }}
            sx={{ width: { xs: 1, sm: 'auto' }, m: (theme) => theme.spacing(1, 1.5, 1.5, 2.5),
                  '& .MuiSvgIcon-root': { mr: 0.5 },
                  '& .MuiInput-underline:before': { borderBottom: 1, borderColor: 'divider', },
            }}
        />
      </Box>

      {ads.map((ad)=>{
        return(

          <Card sx={{ display: 'flex', height: '200px' }}>

          <CardMedia
            component="img"
            sx={{ width: '70%' }}
            image={img1}
            alt="Ads"
          />

          <Box sx={{ display: 'flex', flexDirection: 'column', width: '30%' }}>
            <CardContent sx={{ flex: '1 0 auto' }}>
              <Typography component="div" variant="h5"> {ad.Title} </Typography>
              <Typography variant="subtitle1" color="text.secondary" component="div"> {ad.Description} </Typography>
            </CardContent>

            <CardActions>
              <Button sx={{ alignContent:'center' }} size="small">Accept</Button>
              <Button size="small">Reject</Button>
            </CardActions>
          </Box>
         
        </Card>

    )})}

    </div>
  );

};

export default Advertisement;
