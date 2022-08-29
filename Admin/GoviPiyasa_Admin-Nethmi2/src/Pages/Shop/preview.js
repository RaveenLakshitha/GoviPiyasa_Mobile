import { DataGrid } from "@mui/x-data-grid";
import React, { useEffect, useState } from "react";
import { Button, Modal } from "react-bootstrap";
import "./styles.css";
import { Rating} from "@mui/material";
import axios from "axios";


const Preview = (props) => {

  const [tableData, setTableData] = useState([]);
  const [shopData, setShopData] = useState([]);
  const [userData, setUserData] = useState([]);
  const id = props.id;

  useEffect(()=>{
    const getData = async () => {
      try {
        console.log(id);

        const data = await axios.get("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/shops/"+id);
        setShopData(data.data.data);
        setUserData(data.data.data.user);
        setTableData(data.data.data.shopItems);
      } catch (e) {
        console.log(e);
      }
    };
    getData();
  },[id])


  const columns = [
    { field: 'productName', headerName: 'Item', width:150 },
    { field: 'price', headerName: 'Price', width: 160 },
    { field: 'quantity', headerName: 'Qty', width: 150 },
    { field: 'description', headerName: 'Description', width: 200 },
    { field: 'rating', headerName: 'Rating', width: 120,
        renderCell: (params) => { 
          return(
            <Rating name="read-only" size="small" value={params.getValue(params.id,'rating')} precision={0.5} readOnly />
          );
        }
    },
  ]

  console.log(tableData);


  return ( 
    <div>
      <Modal size="xl" className="modalstyle" show={props.show} onHide={props.handleClose}>
        <Modal.Header closeButton>
          <Modal.Title><h4>Item details</h4></Modal.Title>
        </Modal.Header>
        <Modal.Body scrollable>

          <p className="space"> Shop name : <b> {shopData.shopName} </b>
          
          &emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp;&emsp; 
          
           User name : <b> {userData.userName} </b> </p>
        
          <p className="space"> Item list </p>
        
          <DataGrid
            autoHeight
            rows={tableData}
            columns={columns}
            getRowId={(row) => row._id}
            pageSize={10}
            rowsPerPageOptions={[10]}
            checkboxSelection
            disableSelectionOnClick
          />
         
        </Modal.Body>
        <Modal.Footer>
          <Button variant="secondary" onClick={props.handleClose}>
            Close
          </Button>
        </Modal.Footer>
      </Modal>
    </div>
  );
}
 
export default Preview;