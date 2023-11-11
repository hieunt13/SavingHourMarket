import {
  View,
  Text,
  TouchableOpacity,
  TouchableWithoutFeedback,
  Keyboard,
  StyleSheet,
  Image,
  TextInput,
  ScrollView,
  Pressable,
  Alert,
} from 'react-native';
import Modal, {
  ModalFooter,
  ModalButton,
  ScaleAnimation,
  ModalContent,
} from 'react-native-modals';
import React, {useEffect, useState, useCallback} from 'react';
import auth from '@react-native-firebase/auth';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {COLORS} from '../../constants/theme';
import {icons} from '../../constants';
import {useFocusEffect} from '@react-navigation/native';
import {API} from '../../constants/api';
import {format} from 'date-fns';
import CartEmpty from '../../assets/image/search-empty.png';
import {SwipeListView} from 'react-native-swipe-list-view';
import LoadingScreen from '../../components/LoadingScreen';
import DatePicker from 'react-native-date-picker';
import CheckBox from 'react-native-check-box';

const PickStaff = ({navigation, route}) => {
  const {orderGroupId, staff, mode} = route.params;
  const [initializing, setInitializing] = useState(true);
  const [open, setOpen] = useState(false);
  const [loading, setLoading] = useState(false);
  const [currentUser, setCurrentUser] = useState(null);
  const [staffList, setStaffList] = useState([]);
  const [selectedStaff, setSelectedStaff] = useState(null);
  const [showLogout, setShowLogout] = useState(false);
  const [openValidateDialog, setOpenValidateDialog] = useState(false);
  const [openNotificationDialog, setOpenNotificationDialog] = useState(false);
  const [respondText, setRespondText] = useState(null);

  const onAuthStateChange = async userInfo => {
    // console.log(userInfo);
    if (initializing) {
      setInitializing(false);
    }
    if (userInfo) {
      // check if user sessions is still available. If yes => redirect to another screen
      const userTokenId = await userInfo
        .getIdToken(true)
        .then(token => token)
        .catch(async e => {
          console.log(e);
          return null;
        });
      if (!userTokenId) {
        // sessions end. (revoke refresh token like password change, disable account, ....)
        await AsyncStorage.removeItem('userInfo');
        navigation.navigate('Login');
        return;
      }
      const currentUser = await AsyncStorage.getItem('userInfo');
      // console.log('currentUser', currentUser);
      setCurrentUser(JSON.parse(currentUser));
    } else {
      // no sessions found.
      console.log('user is not logged in');
      await AsyncStorage.removeItem('userInfo');
      navigation.navigate('Login');
    }
  };

  useFocusEffect(
    useCallback(() => {
      // auth().currentUser.reload()
      const subscriber = auth().onAuthStateChanged(
        async userInfo => await onAuthStateChange(userInfo),
      );

      return subscriber;
      // eslint-disable-next-line react-hooks/exhaustive-deps
    }, []),
  );

  useFocusEffect(
    useCallback(() => {
      const fetchData = async () => {
        if (auth().currentUser) {
          const tokenId = await auth().currentUser.getIdToken();
          if (tokenId) {
            setLoading(true);

            fetch(`${API.baseURL}/api/staff/getStaffForDeliverManager`, {
              method: 'GET',
              headers: {
                'Content-Type': 'application/json',
                Authorization: `Bearer ${tokenId}`,
              },
            })
              .then(res => res.json())
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
      };
      fetchData();
    }, []),
  );

  const handlePickStaff = () => {
    if (!staffList.some(item => item.checked === true)) {
      setOpenValidateDialog(true);
      return;
    }
    const assignStaff = async () => {
      if (auth().currentUser) {
        const tokenId = await auth().currentUser.getIdToken();
        if (tokenId) {
          setLoading(true);
          if (mode === 1) {
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
              .then(res => res.text())
              .then(respond => {
                console.log('res:', respond);
                setRespondText(respond);
                setOpenNotificationDialog(true);
                setLoading(false);
              })
              .catch(err => {
                console.log(err);
                setLoading(false);
              });
          }
          if (mode === 2) {
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
              .then(res => res.text())
              .then(respond => {
                console.log('res:', respond);
                setRespondText(respond);
                setOpenNotificationDialog(true);
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
          padding: 20,
          marginBottom: 10,
        }}>
        <TouchableOpacity
          onPress={() => {
            navigation.goBack();
          }}>
          <Image
            source={icons.leftArrow}
            resizeMode="contain"
            style={{width: 35, height: 35, tintColor: COLORS.primary}}
          />
        </TouchableOpacity>
        <Text
          style={{
            fontSize: 25,
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
              fontSize: 20,
              fontFamily: 'Roboto',
              // color: 'black',
              fontWeight: 'bold',
            }}>
            Không tìm được nhân viên nào
          </Text>
        </View>
      ) : (
        <>
          <ScrollView contentContainerStyle={{marginTop: 10}}>
            <View style={{marginBottom: 100, paddingHorizontal: 10}}>
              {staffList.map((item, index) => (
                <View
                  key={item.id}
                  style={{
                    backgroundColor: 'white',
                    marginBottom: 20,
                    // borderRadius: 10,
                  }}>
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
                        padding: 20,
                      }}>
                      <View style={{flexDirection: 'column', gap: 8}}>
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
                            right: -10,
                            top: -10,
                          }}>
                          <Image
                            style={{
                              width: 60,
                              height: 60,
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
                            fontSize: 17,
                            fontWeight: 'bold',
                            fontFamily: 'Roboto',
                            color: 'black',
                          }}>
                          Họ tên : {item?.fullName}
                        </Text>
                        <Text
                          style={{
                            fontSize: 17,
                            fontWeight: 'bold',
                            fontFamily: 'Roboto',
                            color: 'black',
                          }}>
                          Email : {item?.email}
                        </Text>
                      </View>
                      <CheckBox
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
                          const selectedStaffArr = newStaffList.filter(item => {
                            return item.checked === true;
                          });
                          // console.log(selectedStaffArr[0]);
                          setSelectedStaff(selectedStaffArr[0]);
                        }}
                        isChecked={item.checked}
                      />
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
              height: 80,
              width: '100%',
              flex: 1,
              flexDirection: 'row',
              alignItems: 'center',
              justifyContent: 'space-between',
              paddingHorizontal: 15,
              marginTop: 10,
            }}>
            <View style={{flexDirection: 'row', alignItems: 'center'}}>
              {/* <Text style={{fontSize: 18, color: 'black', fontFamily: 'Roboto'}}>
              Tổng cộng:
            </Text> */}
              <Text
                style={{
                  fontSize: 18,
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
                handlePickStaff();
              }}
              style={{
                height: '60%',
                width: '30%',
                backgroundColor: COLORS.primary,
                textAlign: 'center',
                alignItems: 'center',
                justifyContent: 'center',
                borderRadius: 30,
              }}>
              <Text
                style={{
                  color: 'white',
                  fontSize: 20,
                  fontFamily: 'Roboto',
                  fontWeight: 'bold',
                }}>
                Chọn
              </Text>
            </TouchableOpacity>
          </View>
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
                  // textStyle={{color: 'red'}}
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
          <Modal
            width={0.8}
            visible={openNotificationDialog}
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
                  // textStyle={{color: 'red'}}
                  text="OK"
                  onPress={() => {
                    setOpenNotificationDialog(false);
                    navigation.goBack();
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
                  {respondText ? respondText : ''}
                </Text>
              </View>
            </ModalContent>
          </Modal>
        </>
      )}
      {loading && <LoadingScreen />}
    </>
  );
};

export default PickStaff;

const styles = StyleSheet.create({});
