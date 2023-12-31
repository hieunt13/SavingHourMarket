/* eslint-disable prettier/prettier */
import {
  View,
  Text,
  TouchableOpacity,
  TouchableWithoutFeedback,
  Keyboard,
  StyleSheet,
  Image,
  ScrollView,
  Modal,
  Pressable,
  FlatList,
  Switch,
  Dimensions
} from 'react-native';
import React, { useEffect, useState, useCallback, useRef } from 'react';
import auth from '@react-native-firebase/auth';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { COLORS } from '../../constants/theme';
import { icons } from '../../constants';
import { useFocusEffect } from '@react-navigation/native';
import { API } from '../../constants/api';
import { format } from 'date-fns';
import CartEmpty from '../../assets/image/search-empty.png';
import { SwipeListView } from 'react-native-swipe-list-view';
import LoadingScreen from '../../components/LoadingScreen';
import Toast from 'react-native-toast-message';
import DatePicker from 'react-native-date-picker';
import { checkSystemState } from '../../common/utils';
import ModalAlertSignOut from '../../components/ModalAlertSignOut';
const Home = ({ navigation }) => {
  // listen to system state
  useFocusEffect(
    useCallback(() => {
      const onSystemStateChange = checkSystemState(navigation);
    }, []),
  );

  const orderStatus = [
    { display: 'Chờ đóng gói', value: 'PROCESSING' },
    { display: 'Đang đóng gói', value: 'PACKAGING' },
    { display: 'Đã đóng gói', value: 'PACKAGED' },
    { display: 'Giao hàng', value: '' },
    { display: 'Đã huỷ', value: 'CANCEL' },
  ];
  const sortOptions = [
    {
      id: 1,
      name: 'Ngày giao gần nhất',
      param: '&deliveryDateSortType=ASC',
      active: false,
    },
    {
      id: 2,
      name: 'Ngày giao xa nhất',
      param: '&deliveryDateSortType=DESC',
      active: false,
    },
    {
      id: 3,
      name: 'Đơn mới nhất',
      param: '&createdTimeSortType=DESC',
      active: true,
    },
    {
      id: 4,
      name: 'Đơn cũ nhất',
      param: '&createdTimeSortType=ASC',
      active: false,
    },
  ];
  const [initializing, setInitializing] = useState(true);
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [orderList, setOrderList] = useState([]);
  const [visible, setVisible] = useState(false);
  const [editVisible, setEditVisible] = useState(false);
  const [pickupPoint, setPickupPoint] = useState(null);
  const [order, setOrder] = useState(null);
  const [currentUser, setCurrentUser] = useState(null);
  const [timeFrameList, setTimeFrameList] = useState([]);
  const [selectedTimeFrameId, setSelectedTimeFrameId] = useState('');
  const [tempSelectedTimeFrameId, setTempSelectedTimeFrameId] = useState('');
  const [selectedDate, setSelectedDate] = useState('');
  const [tempSelectedDate, setTempSelectedDate] = useState('');
  // isEnable date filter
  const [isEnableDateFilter, setIsEnableDateFilter] = useState(false);
  const [consolidationAreaList, setConsolidationAreaList] = useState([]);
  const [selectedConsolidationAreaId, setSelectedConsolidationAreaId] =
    useState('');
  const [selectSort, setSelectSort] = useState(sortOptions);
  const [tempSelectedSortId, setTempSelectedSortId] = useState(3);
  const [modalVisible, setModalVisible] = useState(false);
  const swipeListViewRef = useRef();
  const isMountingRef = useRef(false);
  const [viewHeight, setViewHeight] = useState(0);
  const [currentStatus, setCurrentStatus] = useState({
    display: 'Chờ đóng gói',
    value: 'PROCESSING',
  });
  const [alertVisible, setAlertVisible] = useState(false);
  const [clickSignOut, setClickSignOut] = useState(false);
  const leftOpenValue = currentStatus.value === 'PACKAGING' ? Dimensions.get('window').width * 0.25 : 0;
  const rightOpenValue = currentStatus.value === 'PROCESSING' ? Dimensions.get('window').width * -0.25 : Dimensions.get('window').width * -0.5;
  const print = async orderId => {
    setLoading(true);
    console.log('print');
    const tokenId = await auth().currentUser.getIdToken();
    if (tokenId) {
      await fetch(
        `${API.baseURL}/api/order/packageStaff/printOrderPackaging?orderId=${orderId}`,
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
          return res.text();
        })
        .then(respond => {
          // console.log('order group', respond);
          if (respond.error) {
            setLoading(false);
            return;
          }
          console.log(respond);
          navigation.navigate('OrderPrint', {
            uri: respond,
          });
          setLoading(false);
        })
        .catch(err => {
          console.log(err);
          setLoading(false);
        });
    }
  };

  const showToast = (message) => {
    Toast.show({
      type: 'success',
      text1: 'Thành công',
      text2: message + '👋',
      visibilityTime: 3000,
    });
  };

  const showToastFail = (message) => {
    Toast.show({
      type: 'unsuccess',
      text1: 'Thất bại',
      text2: message + '👋',
      visibilityTime: 3000,
    });
  };

  const closeRow = (rowMap, rowKey) => {
    if (rowMap[rowKey]) {
      rowMap[rowKey].closeRow();
    }
  };

  const getConsolidationArea = async (pickupPointId, orderStatus) => {
    const tokenId = await auth().currentUser.getIdToken();
    if (tokenId) {
      setLoading(true);
      await fetch(
        `${API.baseURL}/api/productConsolidationArea/getByPickupPointForStaff?pickupPointId=${pickupPointId}`,
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
          // console.log('order group', respond);
          if (respond.error) {
            setLoading(false);
            return;
          }
          if (orderStatus === 1) {
            setConsolidationAreaList(respond);
            setLoading(false);
            setEditVisible(true);
          } else {
            setSelectedConsolidationAreaId('');
            setConsolidationAreaList(respond);
            setLoading(false);
            setVisible(true);
          }
        })
        .catch(err => {
          console.log(err);
          setLoading(false);
        });
    }
  };

  const editConsolidationArea = async () => {
    const tokenId = await auth().currentUser.getIdToken();
    if (tokenId) {
      const consolidationAreaEditRequest = await fetch(
        `${API.baseURL}/api/order/packageStaff/editProductConsolidationArea?orderId=${order.id}&productConsolidationAreaId=${selectedConsolidationAreaId}`,
        {
          method: 'PUT',
          headers: {
            'Content-Type': 'application/json',
            Authorization: `Bearer ${tokenId}`,
          },
        },
      ).catch(err => {
        console.log(err);
        return null;
        // setLoading(false);
      });

      if (!consolidationAreaEditRequest) {
        return;
      }

      if (
        consolidationAreaEditRequest.status === 403 ||
        consolidationAreaEditRequest.status === 401
      ) {
        await auth()
          .currentUser.getIdToken(true)
          .catch(async err => {
            await AsyncStorage.setItem('isDisableAccount', '1');
            return null;
          });
      }

      if (consolidationAreaEditRequest.status === 200) {
        const result = await consolidationAreaEditRequest.text();
        fetchOrderWithFilter();
        showToast(result);
        setEditVisible(false);
      } else {
        const result = await consolidationAreaEditRequest.json();
        setEditVisible(false);
        console.log(result);
      }
    }
  };

  const fetchOrderWithFilter = async () => {
    setLoading(true);
    console.log('fetch order with filter');
    const tokenId = await auth()
      .currentUser.getIdToken()
      .catch(err => console.log(err));
    const sortItem = selectSort.find(item => item.active === true);
    setTempSelectedSortId(sortItem ? sortItem.id : '');
    if (tokenId) {
      await fetch(
        `${API.baseURL
        }/api/order/packageStaff/getOrders?deliveryMethod=DOOR_TO_DOOR&${pickupPoint && pickupPoint.id ? `pickupPointId=${pickupPoint.id}` : ''
        } ${currentStatus.value === ''
          ? `&getOldOrder=true`
          : `&orderStatus=${currentStatus.value}&getOldOrder=true`
        }
        ${selectedDate === ''
          ? ''
          : '&deliveryDate=' + format(Date.parse(selectedDate), 'yyyy-MM-dd')
        }${selectedTimeFrameId === ''
          ? ''
          : '&timeFrameId=' + selectedTimeFrameId
        }${tempSelectedSortId === ''
          ? ''
          : selectSort.find(item => item.id === tempSelectedSortId)?.param
        }`,
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
            if (auth().currentUser) {
              const tokenIdCheck = await auth()
                .currentUser.getIdToken(true)
                .catch(async err => {
                  await AsyncStorage.setItem('isDisableAccount', '1');
                  return null;
                });
              if (!tokenIdCheck) {
                throw new Error();
              }
            }
            // Cac loi 403 khac thi handle duoi day neu co
          }
          return res.json();
        })
        .then(respond => {
          // console.log('order group', respond);
          if (respond.error) {
            setLoading(false);
            return;
          }
          setOrderList(respond);
          setLoading(false);
        })
        .catch(err => {
          console.log('fetch error:', err);
          setLoading(false);
        });
    }
  };

  const handleApplyFilter = () => {
    setSelectSort(
      selectSort.map(item => {
        if (item.id === tempSelectedSortId) {
          return { ...item, active: true };
        }
        return { ...item, active: false };
      }),
    );
    setSelectedTimeFrameId(tempSelectedTimeFrameId);
    // tempSelectedDate != '' && setSelectedDate(tempSelectedDate);
    setSelectedDate(tempSelectedDate);
  };

  const handleApplySort = () => {
    setModalVisible(!modalVisible);
    setLoading(true);
    handleApplyFilter();
  };

  // handle toggle date filter
  const toggleSwitchFilterDate = value => {
    if (value) {
      setTempSelectedDate(new Date());
    } else {
      setTempSelectedDate('');
    }
    setIsEnableDateFilter(value);
  };

  const handleClear = () => {
    setModalVisible(!modalVisible);
    setSelectSort(sortOptions);
    setTempSelectedSortId('');
    setTempSelectedTimeFrameId('');
    setTempSelectedDate('');
    setSelectedTimeFrameId('');
    setSelectedDate('');
    setIsEnableDateFilter(false);
  };

  const handleCancel = () => {
    setVisible(false);
    setEditVisible(false);
  };

  const handleConfirm = () => {
    const confirmPackaging = async () => {
      if (auth().currentUser) {
        const tokenId = await auth().currentUser.getIdToken();
        if (tokenId) {
          setLoading(true);
          fetch(
            `${API.baseURL}/api/order/packageStaff/confirmPackaging?orderId=${order.id}&productConsolidationAreaId=${selectedConsolidationAreaId}`,
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
                showToastFail(error.message);
                fetchOrderWithFilter();
                throw new Error();
              }
              return res.text();
            })
            .then(respond => {
              fetchOrderWithFilter();
              showToast(respond);
            })
            .catch(err => {
              console.log(err);
              setLoading(false);
            });
        }
      }
    };

    const confirmPackaged = async () => {
      if (auth().currentUser) {
        const tokenId = await auth().currentUser.getIdToken();
        if (tokenId) {
          setLoading(true);
          fetch(
            `${API.baseURL}/api/order/packageStaff/confirmPackaged?orderId=${order.id}`,
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
                if (res.status === 409) {
                  const error = await res.json();
                  showToastFail(error.message);
                  fetchOrderWithFilter();
                  throw new Error();
                }
              }
              return res.text();
            })
            .then(respond => {
              fetchOrderWithFilter();
              showToast(respond);
            })
            .catch(err => {
              console.log(err);
              setLoading(false);
            });
        }
      }
    };
    if (order.status === 0) {
      confirmPackaging();
    } else {
      confirmPackaged();
    }
    // fetchData();
    // setLoading(false);
    // The user has pressed the "Delete" button, so here you can do your own logic.
    // ...Your logic
    setVisible(false);
  };

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

  useEffect(() => {
    if (clickSignOut) {
      auth()
        .signOut()
        .then(async () => {
          await AsyncStorage.removeItem('userInfo');
        })
        .catch(e => console.log(e));
    }
  }, [clickSignOut]);

  // init pickup point
  useFocusEffect(
    useCallback(() => {
      const initPickupPoint = async () => {
        // console.log('pick up point :', pickupPoint)
        const pickupPointStorage = await AsyncStorage.getItem('pickupPoint')
          .then(result => JSON.parse(result))
          .catch(error => {
            console.log(error);
            return null;
          });
        if (pickupPointStorage) {
          setPickupPoint(pickupPointStorage);
        } else {
          setPickupPoint({
            id: null,
          });
        }
      };
      initPickupPoint();
    }, []),
  );

  // init time frame
  useFocusEffect(
    useCallback(() => {
      // fetch time frame
      fetch(`${API.baseURL}/api/timeframe/getForHomeDelivery`, {
        method: 'GET',
        headers: {
          'Content-Type': 'application/json',
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
          if (respond.error) {
            return;
          }
          setTimeFrameList(respond);
        })
        .catch(err => {
          console.log(err);
        });
    }, [selectSort, selectedDate, selectedTimeFrameId]),
  );

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

  useEffect(() => {
    isMountingRef.current = true;
  }, []);

  useEffect(() => {
    const fetchData = async () => {
      if (!isMountingRef.current) {
        await fetchOrderWithFilter();
      } else {
        isMountingRef.current = false;
      }
      setLoading(false);
    };
    fetchData();
  }, [
    currentStatus,
    pickupPoint,
    selectSort,
    selectedDate,
    selectedTimeFrameId,
    pickupPoint,
  ]);

  const ModalSortItem = ({ item }) => {
    return (
      <TouchableOpacity
        onPress={() => {
          setTempSelectedSortId(item.id);
        }}
        style={
          item.id == tempSelectedSortId
            ? {
              borderColor: COLORS.primary,
              borderWidth: 1,
              borderRadius: 10,
              margin: 5,
              width: '45%'
            }
            : {
              borderColor: '#c8c8c8',
              borderWidth: 0.2,
              borderRadius: 10,
              margin: 5,
              width: '45%'
            }
        }>
        <Text
          style={
            item.id == tempSelectedSortId
              ? {
                width: "100%",
                paddingVertical: 10,
                textAlign: 'center',
                color: COLORS.primary,
                fontSize: 12,
              }
              : {
                width: "100%",
                paddingVertical: 10,
                textAlign: 'center',
                color: 'black',
                fontSize: 12,
              }
          }>
          {item.name}
        </Text>
      </TouchableOpacity>
    );
  };

  return (
    <TouchableWithoutFeedback
      onPress={() => {
        Keyboard.dismiss;
        setOpen(false);
      }}
      accessible={false}>
      <View style={styles.container}>
        <View style={styles.header}>
          <View style={styles.areaAndLogout}>
            <View style={styles.area}>
              <Text style={{ fontSize: 16 }}>Khu vực:</Text>
              <View style={styles.pickArea}>
                <TouchableOpacity
                  onPress={() => {
                    navigation.navigate('SelectPickupPoint', {
                      setPickupPoint: setPickupPoint,
                    });
                  }}>
                  <View style={styles.pickAreaItem}>
                    <Image
                      resizeMode="contain"
                      style={{
                        width: 20,
                        height: 20,
                        tintColor: COLORS.primary,
                      }}
                      source={icons.location}
                    />

                    <Text
                      style={{
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        color: 'black',
                        maxWidth: 270,
                      }}
                      numberOfLines={1}>
                      {pickupPoint && pickupPoint.id
                        ? pickupPoint.address
                        : 'Chọn điểm giao hàng'}
                      {/* Chọn điểm giao hàng */}
                    </Text>
                  </View>
                </TouchableOpacity>
                {pickupPoint && pickupPoint.id ? (
                  <TouchableOpacity
                    onPress={async () => {
                      setPickupPoint(null);
                      await AsyncStorage.removeItem('pickupPoint');
                    }}>
                    <Image
                      resizeMode="contain"
                      style={{
                        width: 22,
                        height: 22,
                        tintColor: COLORS.primary,
                      }}
                      source={icons.clearText}
                    />
                  </TouchableOpacity>
                ) : (
                  <></>
                )}
              </View>
            </View>
            <View style={styles.logout}>
              <TouchableOpacity
                onPress={() => {
                  setOpen(!open);
                }}>
                <Image
                  resizeMode="contain"
                  style={{ width: 38, height: 38 }}
                  source={{
                    uri: currentUser?.avatarUrl,
                  }}
                />
              </TouchableOpacity>
              {open && (
                <TouchableOpacity
                  style={{
                    position: 'absolute',
                    bottom: -30,
                    zIndex: 100,
                    width: 75,
                    height: 35,
                    justifyContent: 'center',
                    alignItems: 'center',
                    borderRadius: 10,
                    backgroundColor: 'rgb(240,240,240)',
                  }}
                  onPress={() => {
                    setClickSignOut(true);
                  }}>
                  <Text style={{ color: 'red', fontWeight: 'bold' }}>
                    Đăng xuất
                  </Text>
                </TouchableOpacity>
              )}
            </View>
          </View>
          <View
            style={{
              flexDirection: 'row'
            }}>
            <View style={{ flex: 6, paddingTop: '3%', }}>
              <ScrollView horizontal showsHorizontalScrollIndicator={false}>
                {orderStatus.map((item, index) => (
                  <TouchableOpacity
                    key={index}
                    onPress={() => {
                      setLoading(true);
                      setCurrentStatus(item);
                    }}>
                    <View
                      style={[
                        {
                          paddingHorizontal: 15,
                          paddingBottom: 10,
                        },
                        currentStatus.display === item.display && {
                          borderBottomColor: COLORS.primary,
                          borderBottomWidth: 2,
                        },
                      ]}>
                      <Text
                        style={{
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color:
                            currentStatus.display === item.display
                              ? COLORS.primary
                              : 'black',
                          fontWeight:
                            currentStatus.display === item.display
                              ? 'bold'
                              : 400,
                        }}>
                        {item.display}
                      </Text>
                    </View>
                  </TouchableOpacity>
                ))}
              </ScrollView>
            </View>
            <View
              style={{
                justifyContent: 'center',
                alignItems: 'flex-end',
                flex: 1,
              }}>
              <TouchableOpacity
                onPress={() => {
                  setModalVisible(true);
                }}>
                <Image
                  resizeMode="contain"
                  style={{
                    height: 35,
                    tintColor: COLORS.primary,
                    width: 35,
                    marginHorizontal: '1%',
                  }}
                  source={icons.filter}
                />
              </TouchableOpacity>
            </View>
          </View>
        </View>
        <View style={styles.body}>
          {/* Order list */}
          {orderList.length === 0 ? (
            <View style={{ alignItems: 'center', justifyContent: 'center' }}>
              <Image
                style={{ width: '100%', height: '50%' }}
                resizeMode="contain"
                source={CartEmpty}
              />
              <Text
                style={{
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  // color: 'black',
                  fontWeight: 'bold',
                }}>
                Chưa có đơn hàng nào
              </Text>
            </View>
          ) : (
            <View style={{paddingBottom:'15%'}}>
              <SwipeListView
                showsVerticalScrollIndicator={false}
                showsHorizontalScrollIndicator={false}
                style={{paddingBottom:'12%'}}
                ref={swipeListViewRef}
                data={
                  currentStatus.display === 'Giao hàng'
                    ? orderList.filter(
                      order => order.status > 2 && order.status < 6,
                    )
                    : orderList
                }
                keyExtractor={(item, index) => item.id}
                renderItem={(data, rowMap) => (
                  <View
                    key={data.item.id}
                    style={{
                      marginBottom: 20,
                      backgroundColor: 'rgb(240,240,240)',
                      zIndex: 100,
                      padding: 10,
                      borderRadius: 10,
                      shadowColor: '#000',
                      shadowOffset: {
                        width: 0,
                        height: 3,
                      },
                      shadowOpacity: 0.27,
                      shadowRadius: 4.65,
                      elevation: 6,
                      paddingHorizontal: 10,
                      margin: 4,
                    }}
                    onLayout={(event) => {
                      setViewHeight(event.nativeEvent.layout.height); // Set the height in state
                    }}>
                    {/* Order detail */}
                    <TouchableOpacity
                      onPress={() => {
                        navigation.navigate('OrderDetail', {
                          id: data.item.id,
                          orderSuccess: false,
                        });

                      }}
                    >
                      <View style={{ flexDirection: 'row', paddingBottom: 9 }}>
                        <Text
                          style={{
                            flex: 13,
                            fontSize: 20,
                            paddingTop: 6,
                            fontWeight: 'bold',
                            fontFamily: 'Roboto',
                            color:
                              data.item?.status === 6 || data.item?.status === 5
                                ? COLORS.red
                                : COLORS.primary,
                          }}>
                          {data.item?.status === 0 && 'Chờ đóng gói'}
                          {data.item?.status === 1 && 'Đang đóng gói'}
                          {data.item?.status === 2 && 'Đã đóng gói'}
                          {data.item?.status === 3 && 'Đang giao'}
                          {data.item?.status === 4 && 'Giao thành công'}
                          {data.item?.status === 5 && 'Giao thất bại'}
                          {data.item?.status === 6 && 'Đã huỷ'}
                        </Text>
                        {/* {data.item?.status >= 2 &&
                          data.item?.status < 6 &&
                          data.item?.packager?.fullName != null && (
                            <>
                              <View
                                style={{
                                  flex: 3,
                                  alignItems: 'flex-end',
                                  marginTop: 4,
                                  width: 30,
                                  height: 40,
                                  borderRadius: 50, // Half of width and height to make it circular
                                }}>
                                <Image
                                  source={icons.packaged}
                                  resizeMode="contain"
                                  style={{
                                    width: 30,
                                    height: 30,
                                    padding: 15,
                                    tintColor: 'white',
                                    borderRadius: 50, // Half of width and height to make it circular
                                    overflow: 'hidden',
                                    backgroundColor: 'green',
                                  }}
                                />
                              </View>
                              <Text
                                style={{
                                  flex: 7,
                                  alignItems: 'flex-end',
                                  fontSize: 13,
                                  paddingLeft: 5,
                                  paddingTop: 7,
                                  fontWeight: 'bold',
                                  fontFamily: 'Roboto',
                                  color: COLORS.secondary,
                                }}>
                                {data.item?.packager?.fullName}
                              </Text>
                            </>
                          )}
                        {data.item?.status === 1 &&
                          data.item?.packager?.fullName != null && (
                            <>
                              <View
                                style={{
                                  marginLeft: 15,
                                  marginTop: 4,
                                  marginBottom: 10,
                                  width: 30,
                                  height: 30,
                                  borderRadius: 50,
                                  backgroundColor: 'green',
                                  alignItems: 'center',
                                }}>
                                <Image
                                  source={icons.packaging}
                                  resizeMode="contain"
                                  style={{
                                    width: 20,
                                    height: 30,
                                    tintColor: 'white',
                                  }}
                                />
                              </View>
                              <Text
                                style={{
                                  flex: 7,
                                  alignItems: 'flex-end',
                                  fontSize: 12,
                                  paddingLeft: 5,
                                  paddingTop: 7,
                                  fontWeight: 'bold',
                                  fontFamily: 'Roboto',
                                  color: COLORS.secondary,
                                }}>
                                {data.item?.packager?.fullName}
                              </Text>
                            </>
                          )}
                        {data.item?.status === 6 &&
                          data.item?.packager?.fullName != null && (
                            <>
                              <View
                                style={{
                                  marginLeft: 15,
                                  marginTop: 4,
                                  marginBottom: 10,
                                  width: 30,
                                  height: 30,
                                  borderRadius: 50,
                                  backgroundColor: 'green',
                                  alignItems: 'center',
                                }}>
                                <Image
                                  source={icons.packaging}
                                  resizeMode="contain"
                                  style={{
                                    width: 20,
                                    height: 30,
                                    tintColor: 'white',
                                  }}
                                />
                              </View>
                              <Text
                                style={{
                                  flex: 7,
                                  alignItems: 'flex-end',
                                  fontSize: 16,
                                  paddingLeft: 5,
                                  paddingTop: 7,
                                  fontWeight: 'bold',
                                  fontFamily: 'Roboto',
                                  color: COLORS.secondary,
                                }}>
                                {data.item?.packager?.fullName}
                              </Text>
                            </>
                          )} */}
                      </View>
                      <View
                        style={{
                          flexDirection: 'row',
                          alignItems: 'center',
                          justifyContent: 'space-between',
                        }}>
                        <View style={{ flexDirection: 'column', gap: 8 }}>
                          <Text
                            style={{
                              fontSize: 17,
                              fontWeight: 'bold',
                              fontFamily: 'Roboto',
                              color: 'black',
                            }}>
                            Mã đơn hàng:{' '}
                            {data.item?.code}
                          </Text>
                          <Text
                            style={{
                              fontSize: 17,
                              fontFamily: 'Roboto',
                              color: 'black',
                            }}>
                            Thời gian đặt :{' '}
                            {/* {Date.parse(data.item?.createdTime)} */}
                            {format(
                              Date.parse(data.item?.createdTime),
                              'dd/MM/yyyy - HH:mm:ss',
                            )}
                          </Text>
                          <Text
                            style={{
                              fontSize: 17,

                              fontFamily: 'Roboto',
                              color: 'black',
                            }}>
                            Ngày giao :{' '}
                            {format(
                              Date.parse(data.item?.deliveryDate),
                              'dd/MM/yyyy',
                            )}
                          </Text>
                          <Text
                            style={{
                              fontSize: 17,

                              fontFamily: 'Roboto',
                              color: 'black',
                            }}>
                            Khung giờ:{' '}
                            {data.item?.timeFrame
                              ? `${data.item?.timeFrame?.fromHour.slice(
                                0,
                                5,
                              )} đến ${data.item?.timeFrame?.toHour.slice(
                                0,
                                5,
                              )}`
                              : ''}
                          </Text>
                          {data.item?.productConsolidationArea?.address && (
                            <Text
                              style={{
                                fontSize: 17,

                                fontFamily: 'Roboto',
                                color: 'black',
                                maxWidth: '84%',
                              }}>
                              Điểm tập kết:{' '}
                              {data.item?.productConsolidationArea.address}
                            </Text>
                          )}
                        </View>
                        <Image
                          resizeMode="contain"
                          style={{
                            width: 30,
                            height: 30,
                            marginBottom: 30,
                            tintColor:
                              data.item?.status === 6 ? 'grey' : COLORS.primary,
                          }}
                          source={icons.rightArrow}
                        />
                      </View>
                    </TouchableOpacity>
                    {/* *********************** */}
                  </View>
                )}
                renderHiddenItem={(data, rowMap) => (
                  <View
                    key={data.item.id}
                    style={{
                      flexDirection: 'row',
                      justifyContent:
                        data.item?.status === 1 ? 'space-between' : 'flex-end',
                      height: viewHeight,
                      paddingHorizontal: 10,
                      margin: 4,
                    }}>
                    {data.item?.status === 1 && (
                      <TouchableOpacity
                        style={{
                          flex: 5,
                          height: '100%',
                          backgroundColor: 'grey',
                          borderBottomLeftRadius: 10,
                          borderTopLeftRadius: 10,
                          // flex: 1,
                          alignItems: 'center',
                          justifyContent: 'center',
                        }}
                        onPress={() => {
                          print(data.item?.id);
                          closeRow(rowMap, data.item.id);
                        }}>
                        <View>
                          <Image
                            source={icons.print}
                            resizeMode="contain"
                            style={{ width: 40, height: 40, tintColor: 'white' }}
                          />
                        </View>
                      </TouchableOpacity>
                    )}
                    {(data.item?.status === 1 || data.item?.status === 0) && (
                      <>
                        {data.item?.status === 1 && (
                          <>
                            <TouchableOpacity
                              style={{
                                flex: 5,
                                height: '100%',
                                backgroundColor: COLORS.secondary,
                                // flex: 1,
                                marginLeft: 20,
                                alignItems: 'center',
                                justifyContent: 'center',
                              }}
                              onPress={() => {
                                setLoading(true);
                                setConsolidationAreaList([]);
                                getConsolidationArea(
                                  data.item.pickupPoint.id,
                                  data.item.status,
                                );
                                setSelectedConsolidationAreaId(
                                  data.item?.productConsolidationArea.id,
                                );
                                setOrder(data.item);
                                closeRow(rowMap, data.item.id);
                              }}>
                              <View>
                                <Image
                                  source={icons.edit}
                                  resizeMode="contain"
                                  style={{
                                    width: 30,
                                    height: 30,
                                    tintColor: 'white',
                                  }}
                                />
                              </View>
                            </TouchableOpacity>
                            <TouchableOpacity
                              style={
                                {
                                  flex: 5,
                                  height: '100%',
                                  backgroundColor: COLORS.primary,
                                  borderBottomRightRadius: 10,
                                  borderTopRightRadius: 10,
                                  // flex: 1,
                                  alignItems: 'center',
                                  justifyContent: 'center',
                                }}
                              onPress={() => {
                                setLoading(true);
                                setConsolidationAreaList([]);
                                getConsolidationArea(data.item.pickupPoint.id);
                                // console.log(data.item.id);
                                setOrder(data.item);
                                closeRow(rowMap, data.item.id);
                              }}>
                              <View>
                                {data.item?.status === 1 && (
                                  <Image
                                    source={icons.packaged}
                                    resizeMode="contain"
                                    style={{
                                      width: 55,
                                      height: 55,
                                      tintColor: 'white',
                                    }}
                                  />
                                )}
                              </View>
                            </TouchableOpacity>
                          </>
                        )}
                        {data.item?.status === 0 && (
                          <TouchableOpacity
                            style={
                              {
                                width: '33%',
                                height: '100%',
                                backgroundColor: COLORS.primary,
                                borderBottomRightRadius: 10,
                                borderTopRightRadius: 10,
                                // flex: 1,
                                alignItems: 'center',
                                justifyContent: 'center',
                              }}
                            onPress={() => {
                              setLoading(true);
                              setConsolidationAreaList([]);
                              getConsolidationArea(data.item.pickupPoint.id);
                              // console.log(data.item.id);
                              setOrder(data.item);
                              closeRow(rowMap, data.item.id);
                            }}>
                            <View>
                              {data.item?.status === 0 && (
                                <Image
                                  source={icons.packaging}
                                  resizeMode="contain"
                                  style={{
                                    width: 40,
                                    height: 40,
                                    tintColor: 'white',
                                  }}
                                />
                              )}
                              {data.item?.status === 1 && (
                                <Image
                                  source={icons.packaged}
                                  resizeMode="contain"
                                  style={{
                                    width: 55,
                                    height: 55,
                                    tintColor: 'white',
                                  }}
                                />
                              )}
                            </View>
                          </TouchableOpacity>
                        )}

                      </>
                    )}
                  </View>
                )}
                disableLeftSwipe={
                  currentStatus.value === '' ||
                    currentStatus.value === 'PACKAGED' ||
                    currentStatus.value === 'CANCEL'
                    ? true
                    : false
                }
                disableRightSwipe={
                  currentStatus.value === '' ||
                    currentStatus.value === 'PACKAGED' ||
                    currentStatus.value === 'CANCEL' ||
                    currentStatus.value === 'PROCESSING'
                    ? true
                    : false
                }
                leftOpenValue={leftOpenValue}
                rightOpenValue={rightOpenValue}
              />
            </View>
          )}
          {/* ************************ */}
          {/* Modal Sort */}
          <Modal
            animationType="fade"
            transparent={true}
            visible={modalVisible}
            onRequestClose={() => {
              setModalVisible(!modalVisible);
            }}>
            <Pressable
              style={styles.centeredView}>
              <View style={styles.modalSortView}>
                <View
                  style={{
                    flexDirection: 'row',
                    justifyContent: 'space-between',
                  }}>
                  <Text
                    style={{
                      color: 'black',
                      fontSize: 20,
                      fontWeight: 700,
                      textAlign: 'center',
                      paddingBottom: 20,
                    }}>
                    Bộ lọc tìm kiếm
                  </Text>
                  <TouchableOpacity
                    onPress={() => {
                      setModalVisible(!modalVisible);
                      selectSort.map(sort => {
                        if (sort.active) {
                          setTempSelectedSortId(sort.id);
                        }
                      });
                      // setSelectSort(sortOptions);
                    }}>
                    <Image
                      resizeMode="contain"
                      style={{
                        width: 20,
                        height: 20,
                        tintColor: 'grey',
                      }}
                      source={icons.close}
                    />
                  </TouchableOpacity>
                </View>
                <ScrollView
                  showsVerticalScrollIndicator={false}
                  showsHorizontalScrollIndicator={false}>
                  <Pressable>
                    <Text
                      style={{
                        color: 'black',
                        fontSize: 16,
                        fontWeight: 700,
                      }}>
                      Sắp xếp theo
                    </Text>
                    <View
                      style={{
                        flexDirection: 'row',
                        flexWrap: 'wrap',
                        marginVertical: 10,
                        gap: 2,
                        alignItems: 'center'
                      }}>
                      {selectSort.map((item, index) => (
                        <ModalSortItem item={item} key={index} />
                      ))}
                    </View>
                    <Text
                      style={{
                        color: 'black',
                        fontSize: 16,
                        fontWeight: 700,
                      }}>
                      Chọn khung giờ
                    </Text>
                    <View
                      style={{
                        flexDirection: 'row',
                        flexWrap: 'wrap',
                        marginVertical: 10,
                        gap: 2,
                        alignItems: 'center'
                      }}>
                      {timeFrameList &&
                        timeFrameList.map(item => (
                          <TouchableOpacity
                            key={item.id}
                            onPress={() =>
                              item.id === tempSelectedTimeFrameId
                                ? setTempSelectedTimeFrameId('')
                                : setTempSelectedTimeFrameId(item.id)
                            }
                            style={
                              item.id === tempSelectedTimeFrameId
                                ? {
                                  borderColor: COLORS.primary,
                                  borderWidth: 1,
                                  borderRadius: 10,
                                  margin: 5,
                                  width: '45%'
                                }
                                : {
                                  borderColor: '#c8c8c8',
                                  borderWidth: 0.2,
                                  borderRadius: 10,
                                  margin: 5,
                                  width: '45%'
                                }
                            }>
                            <Text
                              style={
                                item.id === tempSelectedTimeFrameId
                                  ? {
                                    width: '100%',
                                    paddingVertical: 10,
                                    textAlign: 'center',
                                    color: COLORS.primary,
                                    fontSize: 12,
                                  }
                                  : {
                                    width: '100%',
                                    paddingVertical: 10,
                                    textAlign: 'center',
                                    color: 'black',
                                    fontSize: 12,
                                  }
                              }>
                              {item.fromHour.slice(0, 5)} đến{' '}
                              {item.toHour.slice(0, 5)}
                            </Text>
                          </TouchableOpacity>
                        ))}
                    </View>
                    <View
                      style={{
                        flexDirection: 'row',
                        justifyContent: 'space-between',
                      }}>
                      <Text
                        style={{
                          color: 'black',
                          fontSize: 16,
                          fontWeight: 700,
                        }}>
                        Chọn ngày giao hàng
                      </Text>
                      <Switch
                        trackColor={{ false: 'grey', true: COLORS.primary }}
                        thumbColor={isEnableDateFilter ? '#f4f3f4' : '#f4f3f4'}
                        // ios_backgroundColor="#3e3e3e"
                        onValueChange={value => {
                          toggleSwitchFilterDate(value);
                        }}
                        value={isEnableDateFilter}
                      />
                    </View>
                    {isEnableDateFilter ? (
                      <View
                        style={{
                          marginVertical: 5,
                          alignItems: 'center',
                          alignSelf: 'center'
                        }}>
                        <DatePicker
                          date={
                            tempSelectedDate === ''
                              ? new Date()
                              : tempSelectedDate
                          }
                          mode="date"
                          androidVariant="nativeAndroid"
                          onDateChange={setTempSelectedDate}
                        />
                      </View>
                    ) : (
                      <></>
                    )}
                  </Pressable>
                </ScrollView>
                <View
                  style={{
                    flexDirection: 'row',
                    justifyContent: 'center',
                    marginTop: '5%',
                  }}>
                  <TouchableOpacity
                    style={{
                      width: '50%',
                      paddingHorizontal: 15,
                      paddingVertical: 10,
                      backgroundColor: 'white',
                      borderRadius: 10,
                      borderColor: COLORS.primary,
                      borderWidth: 0.5,
                      marginRight: '2%',
                    }}
                    onPress={handleClear}>
                    <Text
                      style={{
                        color: COLORS.primary,
                        fontWeight: 'bold',
                        textAlign: 'center',
                      }}>
                      Thiết lập lại
                    </Text>
                  </TouchableOpacity>

                  <TouchableOpacity
                    style={{
                      width: '50%',
                      paddingHorizontal: 15,
                      paddingVertical: 10,
                      backgroundColor: COLORS.primary,
                      color: 'white',
                      borderRadius: 10,
                    }}
                    onPress={handleApplySort}>
                    <Text style={styles.textStyle}>Áp dụng</Text>
                  </TouchableOpacity>
                </View>
              </View>


            </Pressable>
          </Modal>

          {/* Modal Package */}
          <Modal
            animationType="fade"
            transparent={true}
            visible={visible}
            onRequestClose={() => {
              setVisible(!visible);
            }}>
            <Pressable
              onPress={() => setVisible(false)}
              style={styles.centeredView}>
              <View style={styles.modalView}>
                <View
                  style={{
                    flexDirection: 'row',
                    justifyContent: 'space-between',
                  }}>
                  <Text
                    style={{
                      color: 'black',
                      fontSize: 20,
                      fontWeight: 700,
                      textAlign: 'center',
                      paddingBottom: 20,
                    }}>
                    {orderList[0]?.status === 0 && 'Xác nhận đóng gói đơn hàng'}
                    {orderList[0]?.status === 1 &&
                      'Hoàn thành đóng gói đơn hàng'}
                  </Text>
                </View>
                {orderList[0]?.status === 0 && (
                  <>
                    <View
                      style={{
                        flexDirection: 'row',
                        justifyContent: 'space-between',
                      }}>
                      <Text
                        style={{
                          color: 'black',
                          fontSize: 18,
                          fontWeight: 400,
                          paddingBottom: 15,
                        }}>
                        Vui lòng chọn điểm tập kết:
                      </Text>
                    </View>
                    <FlatList
                      style={{ maxHeight: 170 }}
                      data={consolidationAreaList}
                      renderItem={data => (
                        <TouchableOpacity
                          key={data.item.id}
                          onPress={() => {
                            setSelectedConsolidationAreaId(data.item.id);
                          }}
                          style={{
                            paddingVertical: 15,
                            borderTopColor: '#decbcb',
                            borderTopWidth: 0.75,
                          }}>
                          <View
                            style={{
                              flexDirection: 'row',
                              alignItems: 'center',
                              gap: 15,
                              flex: 1,
                              justifyContent: 'space-between',
                            }}>
                            <Image
                              resizeMode="contain"
                              style={{ width: 20, height: 20 }}
                              source={icons.location}
                              tintColor={
                                data.item.id === selectedConsolidationAreaId
                                  ? COLORS.secondary
                                  : 'black'
                              }
                            />
                            <Text
                              style={{
                                fontSize: 16,
                                color:
                                  data.item.id === selectedConsolidationAreaId
                                    ? COLORS.secondary
                                    : 'black',
                                fontFamily: 'Roboto',
                                textDecorationColor: 'red',
                                flexShrink: 1,
                              }}>
                              {data.item.address}
                            </Text>
                          </View>
                        </TouchableOpacity>
                      )}
                    />
                  </>
                )}
                {orderList[0]?.status === 1 && (
                  <Text
                    style={{
                      color: 'grey',
                      fontSize: 16,
                      fontWeight: 'bold',
                      paddingBottom: 20,
                    }}>
                    Bạn đã hoàn thành đóng gói đơn hàng này ?
                  </Text>
                )}

                <View
                  style={{
                    flexDirection: 'row',
                    justifyContent: 'center',
                  }}>

                  <TouchableOpacity
                    style={{
                      width: '100%',
                      paddingHorizontal: 15,
                      paddingVertical: 10,
                      backgroundColor:
                      orderList[0]?.status === 0 && selectedConsolidationAreaId === ''
                          ? COLORS.light_green
                          : COLORS.primary,
                      color: 'white',
                      borderRadius: 10,
                    }}
                    disabled={orderList[0]?.status === 0 && selectedConsolidationAreaId === ''}
                    onPress={() => {
                      handleConfirm();
                    }}>
                    <Text style={styles.textStyle}>Xác nhận</Text>
                  </TouchableOpacity>
                </View>
              </View>
            </Pressable>
          </Modal>

          {/* Modal Edit */}
          <Modal
            animationType="fade"
            transparent={true}
            visible={editVisible}
            onRequestClose={() => {
              setEditVisible(!editVisible);
            }}>
            <Pressable
              onPress={() => setEditVisible(false)}
              style={styles.centeredView}>
              <View style={styles.modalView}>
                <View
                  style={{
                    flexDirection: 'row',
                    justifyContent: 'space-between',
                  }}>
                  <Text
                    style={{
                      color: 'black',
                      fontSize: 20,
                      fontWeight: 700,
                      textAlign: 'center',
                      paddingBottom: 20,
                    }}>
                    Chỉnh sửa điểm tập kết
                  </Text>
                </View>
                <View
                  style={{
                    flexDirection: 'row',
                    justifyContent: 'space-between',
                  }}>
                  <Text
                    style={{
                      color: 'black',
                      fontSize: 18,
                      fontWeight: 400,
                      paddingBottom: 15,
                    }}>
                    Vui lòng chọn điểm tập kết:
                  </Text>
                </View>
                <FlatList
                  showsVerticalScrollIndicator={false}
                  showsHorizontalScrollIndicator={false}
                  style={{ maxHeight: 200, marginHorizontal: 7 }}
                  data={consolidationAreaList}
                  renderItem={data => (
                    <TouchableOpacity
                      key={data.item.id}
                      onPress={() => {
                        setSelectedConsolidationAreaId(data.item.id);
                      }}
                      style={{
                        paddingVertical: 15,
                        borderTopColor: '#decbcb',
                        borderTopWidth: 0.75,
                      }}>
                      <View
                        style={{
                          flexDirection: 'row',
                          alignItems: 'center',
                          gap: 15,
                          flex: 1,
                          justifyContent: 'space-between',
                        }}>
                        <Image
                          resizeMode="contain"
                          style={{ width: 20, height: 20 }}
                          source={icons.location}
                          tintColor={
                            data.item.id === selectedConsolidationAreaId
                              ? COLORS.secondary
                              : 'black'
                          }
                        />
                        <Text
                          style={{
                            fontSize: 16,
                            color:
                              data.item.id === selectedConsolidationAreaId
                                ? COLORS.secondary
                                : 'black',
                            fontFamily: 'Roboto',
                            textDecorationColor: 'red',
                            flexShrink: 1,
                          }}>
                          {data.item.address}
                        </Text>
                      </View>
                    </TouchableOpacity>
                  )}
                />

                <View
                  style={{
                    flexDirection: 'row',
                    justifyContent: 'center',
                  }}>
                  <TouchableOpacity
                    style={{
                      width: '50%',
                      paddingHorizontal: 15,
                      paddingVertical: 10,
                      backgroundColor: 'white',
                      borderRadius: 10,
                      borderColor: COLORS.primary,
                      borderWidth: 0.5,
                      marginRight: '2%',
                    }}
                    onPress={handleCancel}>
                    <Text
                      style={{
                        color: COLORS.primary,
                        fontWeight: 'bold',
                        textAlign: 'center',
                      }}>
                      Đóng
                    </Text>
                  </TouchableOpacity>

                  <TouchableOpacity
                    style={{
                      width: '50%',
                      paddingHorizontal: 15,
                      paddingVertical: 10,
                      backgroundColor: COLORS.primary,
                      color: 'white',
                      borderRadius: 10,
                    }}
                    onPress={() => {
                      editConsolidationArea();
                    }}>
                    <Text style={styles.textStyle}>Xác nhận</Text>
                  </TouchableOpacity>
                </View>
              </View>
            </Pressable>
          </Modal>

          {/* Modal alert disable */}
          <ModalAlertSignOut alertVisible={alertVisible} />
        </View>
        {loading && <LoadingScreen />}
      </View>
    </TouchableWithoutFeedback>
  );
};

export default Home;
const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'white',
  },
  header: {
    // backgroundColor: 'orange',
    paddingHorizontal: "5%",
    zIndex: 100,
    backgroundColor: 'white',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 4,
    elevation: 5,
    flexWrap: 'wrap', // This property makes items wrap inside the container
    justifyContent: 'flex-start', // Adjust as per your requirements
    alignItems: 'flex-start', // A
  },
  body: {
    flex: 11,
    backgroundColor: '#fff',
    marginTop: 10,
    paddingHorizontal: 20,
  },
  areaAndLogout: {
    paddingTop: 10,
    flexDirection: 'row',
  },
  pickArea: {
    paddingVertical: 6,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  area: {
    flex: 7,
    // backgroundColor: 'white',
  },
  logout: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'flex-end',
    marginLeft: 10,
  },
  pickAreaItem: {
    flexDirection: 'row',
    gap: 10,
    alignItems: 'center',
    width: '90%',
  },
  centeredView: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingBottom: '15%',
    backgroundColor: 'rgba(50,50,50,0.5)',
  },
  modalSortView: {
    margin: 20,
    height: '65%',
    backgroundColor: 'white',
    borderRadius: 20,
    padding: 20,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 4,
    elevation: 5,
    zIndex: 10
  },
  modalView: {
    margin: 20,
    backgroundColor: 'white',
    borderRadius: 20,
    padding: 20,
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 4,
    elevation: 5,
    zIndex: 10
  },
  textStyle: {
    color: 'white',
    fontWeight: 'bold',
    textAlign: 'center',
  },
});
