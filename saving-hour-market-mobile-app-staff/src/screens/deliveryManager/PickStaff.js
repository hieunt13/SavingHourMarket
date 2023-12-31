import {
  View,
  Text,
  TouchableOpacity,
  StyleSheet,
  Image,
  ScrollView,
  Pressable,
} from 'react-native';
import Modal, {
  ModalFooter,
  ModalButton,
  ScaleAnimation,
  ModalContent,
} from 'react-native-modals';
import React, {useState, useCallback} from 'react';
import auth from '@react-native-firebase/auth';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {COLORS} from '../../constants/theme';
import {icons} from '../../constants';
import {useFocusEffect} from '@react-navigation/native';
import {API} from '../../constants/api';
import CartEmpty from '../../assets/image/search-empty.png';
import LoadingScreen from '../../components/LoadingScreen';
import CheckBox from 'react-native-check-box';
import Toast from 'react-native-toast-message';
import {checkSystemState} from '../../common/utils';

const PickStaff = ({navigation, route}) => {
  // listen to system state
  useFocusEffect(
    useCallback(() => {
      checkSystemState(navigation);
    }, []),
  );

  const {orderGroupId, deliverDate, timeFrame, staff, mode} = route.params;
  const [initializing, setInitializing] = useState(true);
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [currentUser, setCurrentUser] = useState(null);
  const [staffList, setStaffList] = useState([]);
  const [selectedStaff, setSelectedStaff] = useState(null);
  const [showLogout, setShowLogout] = useState(false);
  const [openValidateDialog, setOpenValidateDialog] = useState(false);
  const [openConfirmModal, setOpenConfirmModal] = useState(false);
  const [config, setConfig] = useState(null);

  // const onAuthStateChange = async userInfo => {
  //   // console.log(userInfo);
  //   if (initializing) {
  //     setInitializing(false);
  //   }
  //   if (userInfo) {
  //     // check if user sessions is still available. If yes => redirect to another screen
  //     const userTokenId = await userInfo
  //       .getIdToken(true)
  //       .then(token => token)
  //       .catch(async e => {
  //         console.log(e);
  //         return null;
  //       });
  //     if (!userTokenId) {
  //       // sessions end. (revoke refresh token like password change, disable account, ....)
  //       await AsyncStorage.removeItem('userInfo');
  //       // navigation.navigate('Login');
  //       navigation.reset({
  //         index: 0,
  //         routes: [{name: 'Login'}],
  //       });
  //       return;
  //     }
  //     const currentUser = await AsyncStorage.getItem('userInfo');
  //     // console.log('currentUser', currentUser);
  //     setCurrentUser(JSON.parse(currentUser));
  //   } else {
  //     // no sessions found.
  //     console.log('user is not logged in');
  //     await AsyncStorage.removeItem('userInfo');
  //     // navigation.navigate('Login');
  //     navigation.reset({
  //       index: 0,
  //       routes: [{name: 'Login'}],
  //     });
  //   }
  // };

  // useFocusEffect(
  //   useCallback(() => {
  //     // auth().currentUser.reload()
  //     const subscriber = auth().onAuthStateChanged(
  //       async userInfo => await onAuthStateChange(userInfo),
  //     );

  //     return subscriber;
  //     // eslint-disable-next-line react-hooks/exhaustive-deps
  //   }, []),
  // );
  //get Current User Info
  useFocusEffect(
    useCallback(() => {
      const getCurrentUser = async () => {
        const currentUser = await AsyncStorage.getItem('userInfo');
        // console.log(JSON.parse(currentUser));
        setCurrentUser(JSON.parse(currentUser));
      };
      getCurrentUser();
    }, []),
  );

  useFocusEffect(
    useCallback(() => {
      const fetchData = async () => {
        const currentUser = await AsyncStorage.getItem('userInfo');
        if (auth().currentUser) {
          const tokenId = await auth().currentUser.getIdToken();
          if (tokenId) {
            if (mode === 1) {
              setLoading(true);

              fetch(
                `${
                  API.baseURL
                }/api/staff/getStaffForDeliverManager?orderType=ORDER_GROUP&orderGroupId=${orderGroupId}&deliverDate=${deliverDate}&timeFrameId=${
                  timeFrame.id
                }&deliverMangerId=${JSON.parse(currentUser).id}`,
                {
                  method: 'GET',
                  headers: {
                    'Content-Type': 'application/json',
                    Authorization: `Bearer ${tokenId}`,
                  },
                },
              )
                .then(async res => {
                  if (res.status === 403 || res.status === 401) {
                    const tokenIdCheck = await auth()
                      .currentUser.getIdToken(true)
                      .catch(async err => {
                        await AsyncStorage.setItem('isDisableAccount', '1');
                        return null;
                      });
                    if (!tokenIdCheck) {
                      throw new Error();
                    }
                    // Cac loi 403 khac thi handle duoi day neu co
                  }
                  return res.json();
                })
                .then(respond => {
                  console.log('staff:', respond.staffList[0]);
                  let res = [];
                  if (staff) {
                    res = respond.staffList.filter(item => {
                      return item.id !== staff.id;
                    });
                  } else {
                    res = respond.staffList;
                  }
                  const list = res.map(item => {
                    return {...item, checked: false};
                  });
                  setStaffList(list);
                  setLoading(false);
                })
                .catch(err => {
                  console.log(err);
                  setLoading(false);
                });
            }
            if (mode === 2) {
              setLoading(true);

              fetch(
                `${
                  API.baseURL
                }/api/staff/getStaffForDeliverManager?orderType=ORDER_BATCH&orderBatchId=${orderGroupId}&deliverDate=${deliverDate}&timeFrameId=${
                  timeFrame.id
                }&deliverMangerId=${JSON.parse(currentUser).id}`,
                {
                  method: 'GET',
                  headers: {
                    'Content-Type': 'application/json',
                    Authorization: `Bearer ${tokenId}`,
                  },
                },
              )
                .then(async res => {
                  if (res.status === 403 || res.status === 401) {
                    const tokenIdCheck = await auth()
                      .currentUser.getIdToken(true)
                      .catch(async err => {
                        await AsyncStorage.setItem('isDisableAccount', '1');
                        return null;
                      });
                    if (!tokenIdCheck) {
                      throw new Error();
                    }
                    // Cac loi 403 khac thi handle duoi day neu co
                  }
                  return res.json();
                })
                .then(respond => {
                  console.log('staff:', respond.staffList[2]);
                  let res = [];
                  if (staff) {
                    res = respond.staffList.filter(item => {
                      return item.id !== staff.id;
                    });
                  } else {
                    res = respond.staffList;
                  }
                  const list = res.map(item => {
                    return {...item, checked: false};
                  });
                  setStaffList(list);
                  setLoading(false);
                })
                .catch(err => {
                  console.log(err);
                  setLoading(false);
                });
            }
            if (mode === 3) {
              setLoading(true);

              fetch(
                `${
                  API.baseURL
                }/api/staff/getStaffForDeliverManager?orderType=SINGLE&deliverDate=${deliverDate}&timeFrameId=${
                  timeFrame.id
                }&deliverMangerId=${JSON.parse(currentUser).id}`,
                {
                  method: 'GET',
                  headers: {
                    'Content-Type': 'application/json',
                    Authorization: `Bearer ${tokenId}`,
                  },
                },
              )
                .then(async res => {
                  if (res.status === 403 || res.status === 401) {
                    const tokenIdCheck = await auth()
                      .currentUser.getIdToken(true)
                      .catch(async err => {
                        await AsyncStorage.setItem('isDisableAccount', '1');
                        return null;
                      });
                    if (!tokenIdCheck) {
                      throw new Error();
                    }
                    // Cac loi 403 khac thi handle duoi day neu co
                  }
                  return res.json();
                })
                .then(respond => {
                  console.log('staff:', respond.staffList);
                  let res = [];
                  if (staff) {
                    res = respond.staffList.filter(item => {
                      return item.id !== staff.id;
                    });
                  } else {
                    res = respond.staffList;
                  }
                  const list = res.map(item => {
                    return {...item, checked: false};
                  });
                  setStaffList(list);
                  setLoading(false);
                })
                .catch(err => {
                  console.log(err);
                  setLoading(false);
                });
            }
          }
        }
      };

      const fetchDataConfig = async () => {
        const currentUser = await AsyncStorage.getItem('userInfo');
        if (auth().currentUser) {
          const tokenId = await auth().currentUser.getIdToken();
          if (tokenId) {
            setLoading(true);
            fetch(`${API.baseURL}/api/configuration/getConfiguration`, {
              method: 'GET',
              headers: {
                'Content-Type': 'application/json',
                Authorization: `Bearer ${tokenId}`,
              },
            })
              .then(async res => {
                if (res.status === 403 || res.status === 401) {
                  const tokenIdCheck = await auth()
                    .currentUser.getIdToken(true)
                    .catch(async err => {
                      await AsyncStorage.setItem('isDisableAccount', '1');
                      return null;
                    });
                  if (!tokenIdCheck) {
                    throw new Error();
                  }
                  // Cac loi 403 khac thi handle duoi day neu co
                }
                return res.json();
              })
              .then(respond => {
                console.log('respond:', respond);
                setConfig(respond);
                setLoading(false);
              })
              .catch(err => {
                console.log(err);
                setLoading(false);
              });
          }
        }
      };
      fetchDataConfig();
      fetchData();
    }, []),
  );

  const showToast = message => {
    Toast.show({
      type: 'success',
      text1: 'Thành công',
      text2: message + '👋',
      visibilityTime: 1000,
    });
  };

  const showFailToast = message => {
    Toast.show({
      type: 'unsuccess',
      text1: 'Thất bại',
      text2: message + '👋',
      visibilityTime: 1000,
    });
  };

  const handlePickStaff = () => {
    if (!staffList.some(item => item.checked === true)) {
      setOpenValidateDialog(true);
      return;
    }
    const assignStaff = async () => {
      if (auth().currentUser) {
        const tokenId = await auth().currentUser.getIdToken();
        if (tokenId) {
          if (mode === 1) {
            setLoading(true);
            fetch(
              `${API.baseURL}/api/order/deliveryManager/assignDeliveryStaffToGroupOrBatch?orderGroupId=${orderGroupId}&staffId=${selectedStaff.id}`,
              {
                method: 'PUT',
                headers: {
                  'Content-Type': 'application/json',
                  Authorization: `Bearer ${tokenId}`,
                },
              },
            )
              .then(async res => {
                if (res.status === 403 || res.status === 401) {
                  const tokenIdCheck = await auth()
                    .currentUser.getIdToken(true)
                    .catch(async err => {
                      await AsyncStorage.setItem('isDisableAccount', '1');
                      return null;
                    });
                  if (!tokenIdCheck) {
                    throw new Error();
                  }
                  // Cac loi 403 khac thi handle duoi day neu co
                }

                if (res.status === 409) {
                  const error = await res.json();
                  showFailToast(error.message);
                  navigation.navigate('OrderGroup');
                  throw new Error();
                }
                return res.text();
              })
              .then(respond => {
                if (respond.code === 409) {
                  showFailToast(respond.message);
                  setLoading(false);
                  return;
                }
                console.log('res:', respond);
                showToast(respond);
                setLoading(false);
                navigation.navigate('OrderGroup');
              })
              .catch(err => {
                console.log(err);
                setLoading(false);
              });
          }
          // if (mode === 2) {
          //   setLoading(true);
          //   fetch(
          //     `${API.baseURL}/api/order/deliveryManager/assignDeliveryStaffToGroupOrBatch?orderBatchId=${orderGroupId}&staffId=${selectedStaff.id}`,
          //     {
          //       method: 'PUT',
          //       headers: {
          //         'Content-Type': 'application/json',
          //         Authorization: `Bearer ${tokenId}`,
          //       },
          //     },
          //   )
          //     .then(res => res.text())
          //     .then(respond => {
          //       console.log('res:', respond);
          //       showToast(respond);
          //       setLoading(false);
          //       navigation.navigate('OrderBatch');
          //     })
          //     .catch(err => {
          //       console.log(err);
          //       setLoading(false);
          //     });
          // }
          if (mode === 3) {
            setLoading(true);
            fetch(
              `${API.baseURL}/api/order/deliveryManager/assignDeliveryStaffToOrder?orderId=${orderGroupId}&staffId=${selectedStaff.id}`,
              {
                method: 'PUT',
                headers: {
                  'Content-Type': 'application/json',
                  Authorization: `Bearer ${tokenId}`,
                },
              },
            )
              .then(async res => {
                if (res.status === 403 || res.status === 401) {
                  const tokenIdCheck = await auth()
                    .currentUser.getIdToken(true)
                    .catch(async err => {
                      await AsyncStorage.setItem('isDisableAccount', '1');
                      return null;
                    });
                  if (!tokenIdCheck) {
                    throw new Error();
                  }
                  // Cac loi 403 khac thi handle duoi day neu co
                }
                
                if (res.status === 409) {
                  const error = await res.json();
                  showFailToast(error.message);
                  navigation.navigate('OrderListForManager');
                  throw new Error();
                }
                return res.text();
              })
              .then(respond => {
                if (respond.code === 409) {
                  showFailToast(respond.message);
                  setLoading(false);
                  return;
                }
                console.log('res:', respond);
                showToast(respond);
                setLoading(false);
                navigation.navigate('OrderListForManager');
              })
              .catch(err => {
                console.log(err);
                setLoading(false);
              });
          }
          // setLoading(false);
        }
      }
    };
    assignStaff();
  };

  const handlePickStaffForBatch = () => {
    const assignStaff = async () => {
      if (auth().currentUser) {
        const tokenId = await auth().currentUser.getIdToken();
        if (tokenId) {
          setLoading(true);
          fetch(
            `${API.baseURL}/api/order/deliveryManager/assignDeliveryStaffToGroupOrBatch?orderBatchId=${orderGroupId}&staffId=${selectedStaff.id}`,
            {
              method: 'PUT',
              headers: {
                'Content-Type': 'application/json',
                Authorization: `Bearer ${tokenId}`,
              },
            },
          )
            .then(async res => {
              if (res.status === 403 || res.status === 401) {
                const tokenIdCheck = await auth()
                  .currentUser.getIdToken(true)
                  .catch(async err => {
                    await AsyncStorage.setItem('isDisableAccount', '1');
                    return null;
                  });
                if (!tokenIdCheck) {
                  throw new Error();
                }
                // Cac loi 403 khac thi handle duoi day neu co
              }

              if (res.status === 409) {
                const error = await res.json();
                showFailToast(error.message);
                navigation.navigate('OrderBatch');
                throw new Error();
              }
              return res.text();
            })
            .then(respond => {
              if (respond.code === 409) {
                showFailToast(respond.message);
                setLoading(false);
                return;
              }
              console.log('res:', respond);
              showToast(respond);
              setLoading(false);
              navigation.navigate('OrderBatch');
            })
            .catch(err => {
              console.log(err);
              setLoading(false);
            });

          // setLoading(false);
        }
      }
    };
    assignStaff();
  };

  return (
    <>
      <View
        style={{
          alignItems: 'center',
          flexDirection: 'row',
          gap: 20,

          backgroundColor: '#ffffff',
          padding: '5%',
          marginBottom: 10,
        }}>
        <TouchableOpacity
          onPress={() => {
            navigation.goBack();
          }}>
          <Image
            source={icons.leftArrow}
            resizeMode="contain"
            style={{width: 30, height: 30, tintColor: COLORS.primary}}
          />
        </TouchableOpacity>
        <Text
          style={{
            fontSize: 24,
            textAlign: 'center',
            color: '#000000',
            fontWeight: 'bold',
            fontFamily: 'Roboto',
          }}>
          Chọn nhân viên
        </Text>
      </View>
      {staffList.length === 0 ? (
        <View style={{alignItems: 'center', justifyContent: 'center'}}>
          <Image
            style={{width: '100%', height: '65%'}}
            resizeMode="contain"
            source={CartEmpty}
          />
          <Text
            style={{
              fontSize: 18,
              fontFamily: 'Roboto',
              // color: 'black',
              fontWeight: 'bold',
            }}>
            Không tìm được nhân viên nào
          </Text>
        </View>
      ) : (
        <>
          <View
            style={{
              backgroundColor: '#FFFFFF',
              marginHorizontal: '3%',
              padding: '5%',
              flexDirection: 'column',
              marginTop: '2%',
              marginBottom: '2%',
              gap: 8,
            }}>
            <Text
              style={{
                fontSize: 20,
                fontWeight: 'bold',
                fontFamily: 'Roboto',
                color: COLORS.primary,
              }}>
              Thông tin
            </Text>
            <Text
              style={{
                fontSize: 16,
                fontWeight: 'bold',
                fontFamily: 'Roboto',
                color: 'black',
              }}>
              Ngày giao hàng : {deliverDate}
            </Text>
            <Text
              style={{
                fontSize: 16,
                fontWeight: 'bold',
                fontFamily: 'Roboto',
                color: 'black',
              }}>
              Giờ giao hàng : {timeFrame?.fromHour} đến {timeFrame?.toHour}
            </Text>
            <Text
              style={{
                fontSize: 14,
                fontWeight: 'bold',
                fontFamily: 'Roboto',
                color: 'orange',
              }}>
              Giới hạn khoảng cách trên mỗi phút là {config.limitMeterPerMinute}
              m. Số khoảng cách vượt quá giới hạn được tính bằng: khoảng cách
              cần giao – (giới hạn khoảng cách trên mỗi phút x số phút chênh
              lệch giữa 2 khung giờ)
            </Text>
          </View>
          <ScrollView
            showsVerticalScrollIndicator={false}
            showsHorizontalScrollIndicator={false}
            contentContainerStyle={{marginTop: '3%'}}>
            <View style={{marginBottom: 100, paddingHorizontal: '3%'}}>
              {staffList.map((item, index) => (
                <View
                  key={item.id}
                  style={
                    item?.isAvailableForDelivering === true
                      ? {
                          backgroundColor: '#FFFFFF',
                          marginBottom: '5%',
                          // borderRadius: 10,
                        }
                      : {backgroundColor: '#E5E5E5', marginBottom: '5%'}
                  }>
                  {/* List staff */}
                  <Pressable
                    onPress={() => {
                      console.log('staff', staff);
                      console.log('orderGroupId', orderGroupId);
                      console.log('selectedStaff', selectedStaff);
                      console.log('mode', mode);
                    }}>
                    <View
                      style={{
                        flexDirection: 'row',
                        alignItems: 'center',
                        justifyContent: 'space-between',
                        padding: '5%',
                      }}>
                      <View style={{flexDirection: 'column', gap: 8, flex: 10}}>
                        <Text
                          style={{
                            fontSize: 20,
                            fontWeight: 'bold',
                            fontFamily: 'Roboto',
                            color: COLORS.primary,
                          }}>
                          Nhân viên
                        </Text>
                        <View
                          style={{
                            position: 'absolute',
                            right: '3%',
                            top: '-6%',
                          }}>
                          <Image
                            style={{
                              width: 45,
                              height: 45,
                              borderRadius: 40,
                            }}
                            resizeMode="contain"
                            source={{
                              uri: `${item.avatarUrl}`,
                            }}
                          />
                        </View>
                        <Text
                          style={{
                            fontSize: 16,
                            fontWeight: 'bold',
                            fontFamily: 'Roboto',
                            color: 'black',
                          }}>
                          Họ tên : {item?.fullName}
                        </Text>
                        <Text
                          style={{
                            fontSize: 16,
                            fontWeight: 'bold',
                            fontFamily: 'Roboto',
                            color: 'black',
                          }}>
                          Email : {item?.email}
                        </Text>
                        {item?.overLimitAlertList.length >= 1
                          ? item.overLimitAlertList.map((item, index) => (
                              <Text
                                key={index}
                                style={{
                                  fontSize: 13,
                                  fontWeight: 'bold',
                                  fontFamily: 'Roboto',
                                  color: 'red',
                                  // width: '75%',
                                }}>
                                * {item.alertMessage} (vượt hơn giới hạn {item.limitExceed})
                              </Text>
                            ))
                          : null}
                        {item?.isAvailableForDelivering === false ? (
                          <Text
                            style={{
                              fontSize: 14,
                              width: '100%',
                              fontWeight: 'bold',
                              fontFamily: 'Roboto',
                              color: 'red',
                            }}>
                            Nhân viên này đã đảm nhận nhóm đơn khác trong cùng
                            khung giờ
                          </Text>
                        ) : null}
                      </View>
                      <View style={{flex: 1}}>
                        <CheckBox
                          disabled={
                            item?.isAvailableForDelivering === true
                              ? false
                              : true
                          }
                          uncheckedCheckBoxColor="#000000"
                          checkedCheckBoxColor={COLORS.primary}
                          onClick={() => {
                            const newStaffList = staffList.map((item, i) => {
                              if (i === index) {
                                if (item.checked === true) {
                                  return {...item, checked: false};
                                }
                                return {...item, checked: true};
                              }
                              return {...item, checked: false};
                            });
                            setStaffList(newStaffList);
                            const selectedStaffArr = newStaffList.filter(
                              item => {
                                return item.checked === true;
                              },
                            );
                            // console.log(selectedStaffArr[0]);
                            setSelectedStaff(selectedStaffArr[0]);
                          }}
                          isChecked={item.checked}
                        />
                      </View>
                    </View>
                  </Pressable>
                  {/* *********************** */}
                </View>
              ))}
            </View>
          </ScrollView>
          <View
            style={{
              position: 'absolute',
              bottom: 0,
              left: 0,
              right: 0,
              backgroundColor: 'white',
              borderTopColor: 'transparent',
              height: 70,
              width: '100%',
              flex: 1,
              flexDirection: 'row',
              alignItems: 'center',
              justifyContent: 'space-between',
              paddingHorizontal: '5%',
              marginTop: 10,
            }}>
            <View style={{flexDirection: 'row', alignItems: 'center'}}>
              {/* <Text style={{fontSize: 18, color: 'black', fontFamily: 'Roboto'}}>
              Tổng cộng:
            </Text> */}
              <Text
                style={{
                  fontSize: 17,
                  color: COLORS.primary,
                  fontFamily: 'Roboto',
                  fontWeight: 'bold',
                }}>
                Nhân viên :{' '}
                <Text style={{color: COLORS.primary}}>
                  {selectedStaff ? selectedStaff.fullName : ''}
                </Text>
              </Text>
            </View>
            <TouchableOpacity
              onPress={() => {
                if (mode === 1 || mode === 3) {
                  handlePickStaff();
                }
                if (mode === 2) {
                  if (!staffList.some(item => item.checked === true)) {
                    setOpenValidateDialog(true);
                    return;
                  }
                  if (selectedStaff?.overLimitAlertList.length >= 1) {
                    setOpenConfirmModal(true);
                  } else {
                    handlePickStaffForBatch();
                  }
                  // setOpenConfirmModal(true);
                }
              }}
              style={{
                height: '50%',
                width: '25%',
                backgroundColor: COLORS.primary,
                textAlign: 'center',
                alignItems: 'center',
                justifyContent: 'center',
                borderRadius: 30,
              }}>
              <Text
                style={{
                  color: 'white',
                  fontSize: 17,
                  fontFamily: 'Roboto',
                  fontWeight: 'bold',
                }}>
                Chọn
              </Text>
            </TouchableOpacity>
          </View>

          {/* Validate Dialog */}
          <Modal
            width={0.8}
            visible={openValidateDialog}
            onTouchOutside={() => {
              setOpenValidateDialog(false);
            }}
            dialogAnimation={
              new ScaleAnimation({
                initialValue: 0, // optional
                useNativeDriver: true, // optional
              })
            }
            footer={
              <ModalFooter>
                <ModalButton
                  textStyle={{color: 'grey'}}
                  text="Đóng"
                  onPress={() => {
                    setOpenValidateDialog(false);
                  }}
                />
              </ModalFooter>
            }>
            <ModalContent>
              <View
                style={{
                  padding: 20,
                  alignItems: 'center',
                  justifyContent: 'center',
                }}>
                <Text
                  style={{
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    color: 'black',
                    textAlign: 'center',
                  }}>
                  Vui lòng chọn nhân viên giao hàng
                </Text>
              </View>
            </ModalContent>
          </Modal>
          {/* ---------------------------------------- */}

          {/* Confirm Modal */}
          <Modal
            width={0.8}
            visible={openConfirmModal}
            onTouchOutside={() => {
              setOpenConfirmModal(false);
            }}
            dialogAnimation={
              new ScaleAnimation({
                initialValue: 0, // optional
                useNativeDriver: true, // optional
              })
            }
            footer={
              <ModalFooter>
                <ModalButton
                  textStyle={{color: 'grey'}}
                  text="Đóng"
                  onPress={() => {
                    setOpenConfirmModal(false);
                  }}
                />
                <ModalButton
                  textStyle={{color: COLORS.primary}}
                  text="Xác nhận"
                  onPress={() => {
                    setOpenConfirmModal(false);
                    handlePickStaffForBatch();
                  }}
                />
              </ModalFooter>
            }>
            <ModalContent>
              <View
                style={{
                  padding: 20,
                  alignItems: 'center',
                  justifyContent: 'center',
                }}>
                {/* {selectedStaff?.overLimitAlertList.map((item, index) => (
                  <Text
                    key={index}
                    style={{
                      fontSize: 20,
                      fontFamily: 'Roboto',
                      color: 'black',
                      textAlign: 'center',
                    }}>
                    {item.alertMessage}
                  </Text>
                ))} */}
                <Text
                  style={{
                    fontSize: 20,
                    fontFamily: 'Roboto',
                    color: 'black',
                    textAlign: 'center',
                  }}>
                  Xác nhận giao việc cho nhân viên {selectedStaff?.fullName}
                </Text>
              </View>
            </ModalContent>
          </Modal>
          {/* ---------------------------------- */}
        </>
      )}
      {loading && <LoadingScreen />}
    </>
  );
};

export default PickStaff;

const styles = StyleSheet.create({});
