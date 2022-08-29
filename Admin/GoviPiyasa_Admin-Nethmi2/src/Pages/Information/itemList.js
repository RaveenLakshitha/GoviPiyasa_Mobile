import * as React from 'react';
import { Button } from "react-bootstrap";
import "./styles.css"
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import CardMedia from '@mui/material/CardMedia';
// import { Box, IconButton } from "@mui/material";
// import TextField from '@mui/material/TextField';
// import ClearIcon from '@mui/icons-material/Clear';
// import SearchIcon from '@mui/icons-material/Search';
import Typography from '@mui/material/Typography';
import InfoCropForm from '../../Components/InfoCropForm';
import { useParams, useNavigate } from 'react-router-dom';
import { useState, useEffect } from "react";
import axios from "axios";


const Crops = () => {

  const [crops, setCrops] = useState([]);
  const [show, setShow] = useState(false);
  // const [platform, setPlatform] = useState([]);
  // const [searchText, setSearchText] = useState('');
  const navigate = useNavigate();

  let params = useParams();
  console.log(params);

  const handleClose = () => setShow(false);
  const handleShow = () => setShow(true);

  
  const getCrops = async (id) => {
    try {
      const data = await axios.get("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/infoCategories/getCategoryByParent/"+params.id);
      //setPlatform(data.data.data);
      setCrops(data.data.data);
    } catch (e) {
      console.log(e);
    }
  }

  useEffect(()=>{
    getCrops();
  },[crops])


  const loadInfo = (id) => {
    navigate("/information/crops/details/"+id);
  }

  // //search function
  // function escapeRegExp(value) {
  //   return value.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&');
  // }
  // const requestSearch = (searchValue) => {
  //   const searchRegex = new RegExp(escapeRegExp(searchValue), 'i');
  //   const filteredRows = platform.filter((row) => {
  //       return searchRegex.test(row.categoryName) 
  //   });
  //   setCrops(filteredRows);
  // };


  return ( 
    <div className="content">
      <div className="row">
        
      {/* <Box>
        <TextField variant="standard" value={searchText}
          onChange={(e) => { setSearchText(e.target.value); requestSearch(e.target.value) }}
          placeholder="Search..."
            InputProps={{
              startAdornment: <SearchIcon fontSize="small" color="action" />,
              endAdornment: (
                <IconButton title="Clear" aria-label="Clear" size="small"
                  style={{ visibility: searchText ? 'visible' : 'hidden', borderRadius: "57%", paddingRight: "1px", margin: "0", fontSize: "1.25rem" }}
                  onClick={(e) => {setSearchText(''); setCrops(platform)} }
                >
                  <ClearIcon fontSize="small" color="action" />
                </IconButton>
              ),
            }}
            sx={{ width: { xs: 1, sm: 'auto' }, m: (theme) => theme.spacing(1, 1.5, 1.5, 2.5),
                  '& .MuiSvgIcon-root': { mr: 0.5 },
                  '& .MuiInput-underline:before': { borderBottom: 1, borderColor: 'divider', },
            }}
        /> */}
      
      
        <div className="col-12">
          <Button variant="success" className="float-sm-end m-3" size="sm" onClick={handleShow} >
            Add Crop
          </Button>
          <InfoCropForm show={show} title="Add Crop" handleClose={handleClose} />
        </div>
        {/* </Box> */}
     </div>


     <div className="grid">

    {crops.map((crop) => {
      if(crop.categoryType === "Sub"){

      return (

      // <Link to="/information/crops/details" style={{textDecoration :'none'}}>

        <Card sx={{ width: 150, height: 180, ':hover': { boxShadow: 6} }} className="cards" hoverable 
              onClick={()=>loadInfo(crop._id)}>
          <CardMedia
            component="img" height="120"
            image={crop.image}
          />
          <CardContent>
            <Typography gutterBottom variant="h6" fontSize={"medium"} component="div" textAlign={"center"}>
              {crop.categoryName}
            </Typography>
          </CardContent>
        </Card>

      // </Link>

      )}})}
           
            
        
        </div>
    </div>
   );
}
 
export default Crops;