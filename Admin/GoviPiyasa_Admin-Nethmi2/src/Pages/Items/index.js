import axios from "axios";
import { useEffect, useState } from "react";
import "../../App.css";
import * as React from "react";
import { Badge } from "react-bootstrap";
import { DataGrid } from "@mui/x-data-grid";
import { IconButton} from "@mui/material";
import Preview from "./preview";
import { Box } from "@mui/system";
import TextField from '@mui/material/TextField';
import ClearIcon from '@mui/icons-material/Clear';
import SearchIcon from '@mui/icons-material/Search';
import DeleteIcon from "@mui/icons-material/Delete";
import RemoveRedEyeIcon from '@mui/icons-material/RemoveRedEye';


const Items = () => {
  //const [search, setSearch] = useState("");
  const [show, setShow] = useState(false);
  const [tableData, setTableData] = useState([]);
  const [hoveredRow, setHoveredRow] = useState(null);
  const [platform, setPlatform] = useState([]);
  const [searchText, setSearchText] = useState('');

  const handleDelete = (id) => {
    setTableData(tableData.filter((data) => data._id !== id));
    alert("Deleted!");
    console.log(id);
  };

  const handleView = (id) => { setShow(true); }
  const handleClose = (id) => { setShow(false); }

  const onMouseEnterRow = (event) => {
    const id = event.currentTarget.getAttribute("data-id");
    setHoveredRow(id);
  };

  const onMouseLeaveRow = (event) => {
    setHoveredRow(null);
  };


  //search function
  function escapeRegExp(value) {
    return value.replace(/[-[\]{}()*+?.,\\^$|#\s]/g, '\\$&');
  }
  const requestSearch = (searchValue) => {
    const searchRegex = new RegExp(escapeRegExp(searchValue), 'i');
    const filteredRows = platform.filter((row) => {
      
        return searchRegex.test(row.userName);
    });
    setTableData(filteredRows);
  };


  const getProductData = async () => {
    try {
      const data = await axios.get("https://govi-piyasa-v-0-1.herokuapp.com/api/v1/items");
      setTableData(data.data.data);
    } catch (e) {
      console.log(e);
    }
  };

  useEffect(()=>{
    getProductData();
  },[])

  
  const columns = [
    { field: 'productName', headerName: 'Item', width:150 },
    { field: 'categoryName', headerName: 'Category', width:120 },
    { field: 'price', headerName: 'Price', width: 60 },
    { field: 'description', headerName: 'Description', width: 200},
    { field: 'quantity', headerName: 'Qty', width: 50 },
    { field: 'itemRatings', headerName: 'Ratings', width: 80 },
    { field: 'shopName', headerName: 'Shop', width: 100 ,
      valueGetter: (params) => {
        return params.getValue(params.id, "shopId").shopName;
      }
    },
    { field: 'avilability', headerName: 'Status', width: 100,
      renderCell: (params) => { 
        return(
            (params.getValue(params.id,'avilability') ==="Available") ? <Badge pill bg="primary">Available</Badge> : 
                                                                        <Badge pill bg="danger">Not Available</Badge>)
      }
    },
    { field: "actions", headerName: "Actions", width: 100, sortable: false, disableColumnMenu: true,
      renderCell: (params) => {
        if (hoveredRow === params.id) {
          return (
            <Box
              sx={{ backgroundColor: "whitesmoke", width: "100%", height: "100%", display: "flex",
                justifyContent: "center", alignItems: "center"
              }}
            >
              <IconButton onClick={() => handleDelete(params.id)}>
                <DeleteIcon color="error" />
              </IconButton>
              <IconButton >
                <RemoveRedEyeIcon color="info" onClick={() => handleView(params.id)}/>
              </IconButton>
              <Preview show={show} id={params.id} handleClose={handleClose}/>
            </Box>
          );
        } else return null;
      }
    }
  ]

  

  return (
    <div className="content">
      <h3>Item list</h3>
      
      <Box>
        <TextField variant="standard" value={searchText}
          onChange={(e) => { setSearchText(e.target.value); requestSearch(e.target.value) }}
          placeholder="Search..."
            InputProps={{
              startAdornment: <SearchIcon fontSize="small" color="action" />,
              endAdornment: (
                <IconButton title="Clear" aria-label="Clear" size="small"
                  style={{ visibility: searchText ? 'visible' : 'hidden', borderRadius: "57%", paddingRight: "1px", margin: "0", fontSize: "1.25rem" }}
                  onClick={(e) => {setSearchText(''); setTableData(platform)} }
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

      <br></br>


      <div style={{ height: 500, width: "100%", padding: "1em" }}>
        <DataGrid
          rows={tableData}
          columns={columns}
          getRowId={(row) => row._id}
          pageSize={10}
          rowsPerPageOptions={[10]}
          checkboxSelection
          disableSelectionOnClick
          initialState={{ pinnedColumns: { right: ["actions"] } }}
          componentsProps={{
            row: {
              onMouseEnter: onMouseEnterRow,
              onMouseLeave: onMouseLeaveRow
            }
          }}
        >  
        </DataGrid>
      </div>
      
    </div>
  );
};

export default Items;
