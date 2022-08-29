import { useState, useEffect } from "react";
import { Button } from "react-bootstrap";
import "../../App.css";
import InfoCategoryForm from "../../Components/InfoCategoryForm";
import axios from "axios";
import "./styles.css"
import { useNavigate } from "react-router-dom";
import {Card, CardContent, IconButton, Typography } from '@mui/material';
import DeleteIcon from "@mui/icons-material/Delete";



const Information = () => {

  const navigate = useNavigate();

  const [show, setShow] = useState(false);
  const [category, setCategory] = useState([]);

  const handleClose = () => setShow(false);
  const handleShow = () => setShow(true);


  const getCategory = async () => {
    try {
      const data = await axios.get("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/infoCategories");
      setCategory(data.data.data);

    } catch (e) {
      console.log(e);
    }
  }

  const loadCrops = (id) => {
    navigate("/information/crops/"+id);
  }

  useEffect(()=>{
    getCategory();
  },[category])




  return (
    <div className="content">
      <div className="m-1">
        <div className="row">
          {/* <div className="col-5">
            <input type="text" placeholder="Search..." />
          </div> */}
          <div className="col-12">
            <Button variant="success" className="float-sm-end m-3" size="sm" onClick={handleShow} >
              Add Category
            </Button>
            <InfoCategoryForm show={show} title="Add Category" handleClose={handleClose} />
          </div>
        </div>

        <div className="w-100">
  
          <div className="grid">

            {/* <Link to={"/information/crops/"+parentId}>  */}

        {category.map((cat) => {
          if(cat.categoryType === "Main"){

          return (

            <div key={cat._id} onClick={()=>loadCrops(cat._id)}>

            {/* <Link to="/information/crops/" style={{textDecoration :'none'}}> */}

              <Card sx={{ width: 250, maxHeight:50, ':hover': { boxShadow: 6} }} className="cards" key={cat._id}>
                <CardContent>
                  <Typography gutterBottom variant="h6" fontSize={"medium"} component="div" textAlign={"left"}>
                    {cat.categoryName}
                  </Typography>
                </CardContent>
                {/* <IconButton style={{position: 'absolute', flexDirection: 'row', float: 'right'}}>
                <DeleteIcon color="error" />
               </IconButton> */}
              </Card>  
              

              {/* </Link> */}
              
              </div> 

          )}})}
            
            
          </div>
        </div>
      </div>
    </div>
  );
};


export default Information;

