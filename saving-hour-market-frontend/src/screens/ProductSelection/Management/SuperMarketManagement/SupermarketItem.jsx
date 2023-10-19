import { Dialog } from "@mui/material";
import React, { useState } from "react";
import EditSuperMarket from "./EditSuperMarket";
import MuiAlert from "@mui/material/Alert";
import { Snackbar } from "@mui/material";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { faArrowDown, faXmark } from "@fortawesome/free-solid-svg-icons";
import { auth } from "../../../../firebase/firebase.config";
import { API } from "../../../../contanst/api";

const Alert = React.forwardRef(function Alert(props, ref) {
  return <MuiAlert elevation={6} ref={ref} variant="filled" {...props} />;
});

const SupermarketItem = ({
  item,
  i,
  page,
  setTotalPage,
  setSuperMarketList,
  searchValue,
  setError,
  error,
}) => {
  const [openEdit, setOpenEdit] = useState(false);
  const handleOpenEdit = () => setOpenEdit(true);
  const handleCloseEdit = () => setOpenEdit(false);
  const [openDelete, setOpenDelete] = useState(false);
  const handleOpenDelete = () => setOpenDelete(true);
  const handleCloseDelete = () => setOpenDelete(false);

  const [openSnackbar, setOpenSnackbar] = useState({
    open: false,
    vertical: "top",
    horizontal: "right",
    severity: "error",
  });
  const { vertical, horizontal } = openSnackbar;
  const handleCloseSnackbar = () => {
    setOpenSnackbar({ ...openSnackbar, open: false });
  };

  const handleDelete = async () => {
    const tokenId = await auth.currentUser.getIdToken();
    fetch(
      `${API.baseURL}/api/supermarket/changeStatus?supermarketId=${item.id}&status=DISABLE`,
      {
        method: "PUT",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${tokenId}`,
        },
      }
    )
      .then((res) => res.json())
      .then((respond) => {
        if (respond?.error) {
          setOpenSnackbar({ ...openSnackbar, open: true, severity: "error" });
          setError(respond.error);
          return;
        }
        fetch(
          `${API.baseURL}/api/supermarket/getSupermarketForStaff?page=${
            page - 1
          }&limit=6&name=${searchValue}`,
          {
            method: "GET",
            headers: {
              "Content-Type": "application/json",
              Authorization: `Bearer ${tokenId}`,
            },
          }
        )
          .then((res) => res.json())
          .then((data) => {
            setSuperMarketList(data.supermarketList);
            setTotalPage(data.totalPage);
            handleCloseDelete();
            setOpenSnackbar({
              ...openSnackbar,
              open: true,
              severity: "success",
            });
            setError("Vô hiệu hóa thành công");
          })
          .catch((err) => console.log(err));
      })
      .catch((err) => console.log(err));
  };
  return (
    <tr key={i} className="table-body-row">
      <td>{i + 1}</td>
      <td>{item.name}</td>
      <td
        style={{
          position: "relative",
        }}
      >
        <FontAwesomeIcon
          style={{ marginRight: 10 }}
          data-bs-toggle="dropdown"
          aria-expanded="false"
          className="arrow-down"
          icon={faArrowDown}
        />
        {item.supermarketAddressList[0].address}
        <ul class="dropdown-menu">
          {item.supermarketAddressList.map((address) => (
            <li>{address.address}</li>
          ))}
        </ul>
      </td>
      <td>{item.phone}</td>
      <td>
        <i onClick={handleOpenEdit} class="bi bi-pencil-square"></i>
        <i onClick={handleOpenDelete} class="bi bi-trash-fill"></i>
      </td>
      <Dialog
        onClose={handleCloseEdit}
        aria-labelledby="customized-dialog-title"
        open={openEdit}
      >
        <EditSuperMarket
          searchValue={searchValue}
          setTotalPage={setTotalPage}
          page={page}
          setSuperMarketList={setSuperMarketList}
          handleClose={handleCloseEdit}
          supermarket={item}
          setOpenSnackbar={setOpenSnackbar}
          openSnackbar={openSnackbar}
          setError={setError}
          handleCloseSnackbar={handleCloseSnackbar}
        />
      </Dialog>
      <Dialog
        onClose={handleCloseDelete}
        aria-labelledby="customized-dialog-title"
        open={openDelete}
      >
        <div className={`modal__container `}>
          <div className="modal__container-header">
            <h3 className="modal__container-header-title">Xóa siêu thị</h3>
            <FontAwesomeIcon onClick={handleCloseDelete} icon={faXmark} />
          </div>
        </div>

        <div className={`modal__container-body `}>
          <p style={{ fontSize: "16px", color: "#212B36" }}>
            Bạn có chắc muốn xóa siêu thị này
          </p>
        </div>
        {/* modal footer */}
        <div className="modal__container-footer">
          <div className="modal__container-footer-buttons">
            <button
              onClick={handleCloseDelete}
              className="modal__container-footer-buttons-close"
            >
              Đóng
            </button>
            <button
              onClick={handleDelete}
              className="modal__container-footer-buttons-create"
            >
              Xóa
            </button>
          </div>
        </div>
        {/* *********************** */}
      </Dialog>
      <Snackbar
        open={openSnackbar.open}
        autoHideDuration={1000}
        anchorOrigin={{ vertical, horizontal }}
        onClose={handleCloseSnackbar}
      >
        <Alert
          onClose={handleCloseSnackbar}
          severity={openSnackbar.severity}
          sx={{
            width: "100%",
            fontSize: "15px",
            alignItem: "center",
          }}
        >
          {error}
        </Alert>
      </Snackbar>
    </tr>
  );
};

export default SupermarketItem;