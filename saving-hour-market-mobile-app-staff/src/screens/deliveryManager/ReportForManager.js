import {
  View,
  Text,
  TouchableOpacity,
  TouchableWithoutFeedback,
  Keyboard,
  StyleSheet,
  Image,
  ScrollView,
  Pressable,
} from 'react-native';
import React, {useState, useCallback} from 'react';
import auth from '@react-native-firebase/auth';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {COLORS} from '../../constants/theme';
import {icons} from '../../constants';
import {useFocusEffect} from '@react-navigation/native';
import {API} from '../../constants/api';
import CartEmpty from '../../assets/image/search-empty.png';
import LoadingScreen from '../../components/LoadingScreen';
import {checkSystemState} from '../../common/utils';
import messaging from '@react-native-firebase/messaging';

const ReportForManager = ({navigation}) => {
  // listen to system state
  useFocusEffect(
    useCallback(() => {
      checkSystemState(navigation);
    }, []),
  );

  const [initializing, setInitializing] = useState(true);
  const [loading, setLoading] = useState(false);
  const [currentUser, setCurrentUser] = useState(null);
  const [showLogout, setShowLogout] = useState(false);
  const [deliverReportList, setDeliverReportList] = useState(null);
  const [successDeliveredOrder, setSuccessDeliveredOrder] = useState(null);
  const [deliveringOrder, setDeliveringOrder] = useState(null);
  const [failDeliveredOrder, setFailDeliveredOrder] = useState(null);
  const [waitingForAssignOrder, setWaitingForAssignOrder] = useState(null);

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
  //     //   console.log('currentUser', JSON.parse(currentUser).id);
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
            setLoading(true);
            fetch(
              `${
                API.baseURL
              }/api/order/deliveryManager/getReport?deliverManagerId=${
                JSON.parse(currentUser).id
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
                console.log('report', respond.deliverReportList[0].staff);
                setDeliverReportList(respond.deliverReportList);
                setSuccessDeliveredOrder(respond.successDeliveredOrder);
                setDeliveringOrder(respond.deliveringOrder);
                setFailDeliveredOrder(respond.failDeliveredOrder);
                setWaitingForAssignOrder(respond.waitingForAssignOrder);
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

  return (
    <TouchableWithoutFeedback
      onPress={() => {
        Keyboard.dismiss;
        // setOpen(false);
        setShowLogout(false);
      }}
      accessible={false}>
      <View style={styles.container}>
        <View style={styles.header}>
          <View style={styles.pagenameAndLogout}>
            <View style={styles.pageName}>
              <Text style={{fontSize: 24, color: 'white', fontWeight: 'bold'}}>
                Báo cáo
              </Text>
            </View>
            <View style={styles.logout}>
              <TouchableOpacity
                onPress={() => {
                  setShowLogout(!showLogout);
                }}>
                <Image
                  resizeMode="contain"
                  style={{width: 35, height: 35, borderRadius: 30}}
                  source={{
                    uri: currentUser?.avatarUrl,
                  }}
                />
              </TouchableOpacity>
              {showLogout && (
                <TouchableOpacity
                  style={{
                    position: 'absolute',
                    bottom: -34,
                    left: -10,
                    zIndex: 100,
                    width: 74,
                    height: 30,
                    justifyContent: 'center',
                    alignItems: 'center',
                    borderRadius: 10,
                    backgroundColor: 'rgb(240,240,240)',
                  }}
                  onPress={() => {
                    messaging()
                    .unsubscribeFromTopic('MANAGER_NOTIFICATION')
                    .then(() => console.log('Unsubscribed to topic!'));
                    auth()
                      .signOut()
                      .then(async () => {
                        await AsyncStorage.removeItem('userInfo');
                      })
                      .catch(e => console.log(e));
                  }}>
                  <Text
                    style={{color: 'red', fontWeight: 'bold', fontSize: 14}}>
                    Đăng xuất
                  </Text>
                </TouchableOpacity>
              )}
            </View>
          </View>
          <View
            style={{
              backgroundColor: 'rgb(255,255,255)',
              borderRadius: 10,
              marginTop: '5%',
              flexDirection: 'column',
              padding: '5%',
              shadowColor: '#000',
              shadowOffset: {
                width: 0,
                height: 6,
              },
              shadowOpacity: 0.39,
              shadowRadius: 8.3,
              elevation: 13,
            }}>
            <View
              style={{
                flexDirection: 'row',
                justifyContent: 'space-between',
                // alignItems: 'center',
                borderBottomWidth: 0.5,
                paddingBottom: 10,
              }}>
              <View style={{gap: 3}}>
                <Text style={{fontSize: 18, fontWeight: '700'}}>
                  Tổng số đơn hàng
                </Text>
                <Text
                  style={{
                    fontSize: 20,
                    color: 'black',
                    fontWeight: 'bold',
                    alignSelf: 'center',
                  }}>
                  {deliveringOrder + successDeliveredOrder + failDeliveredOrder}
                </Text>
              </View>
              <Pressable
                style={{
                  flexDirection: 'row',
                  justifyContent: 'center',
                  alignItems: 'center',
                  gap: 5,
                }}
                onPress={() => {
                  navigation.navigate('DailyReportForManager');
                }}>
                <Text
                  style={{
                    fontSize: 18,
                    color: COLORS.secondary,
                    fontWeight: '500',
                  }}>
                  Chi tiết
                </Text>
                <Image
                  resizeMode="contain"
                  style={{
                    width: 14,
                    height: 14,
                    tintColor: COLORS.secondary,
                  }}
                  source={icons.right}
                />
              </Pressable>
            </View>
            <View
              style={{
                flexDirection: 'row',
                justifyContent: 'space-between',
                paddingTop: 10,
              }}>
              <TouchableOpacity
                onPress={() => {
                  navigation.navigate('OrderListForReport', {
                    type: 'success',
                    mode: 1,
                    date: null,
                  });
                }}
                style={{
                  justifyContent: 'center',
                  alignItems: 'center',
                  gap: 7,
                }}>
                <Text style={{fontSize: 16, fontWeight: '500'}}>
                  Đơn thành công
                </Text>
                <Text
                  style={{fontSize: 14, fontWeight: 'bold', color: 'black'}}>
                  {successDeliveredOrder}
                </Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => {
                  navigation.navigate('OrderListForReport', {
                    type: 'delivering',
                    mode: 1,
                    date: null,
                  });
                }}
                style={{
                  justifyContent: 'center',
                  gap: 7,
                  alignItems: 'center',
                }}>
                <Text style={{fontSize: 16, fontWeight: '500'}}>
                  Đơn đang giao
                </Text>
                <Text
                  style={{fontSize: 14, fontWeight: 'bold', color: 'black'}}>
                  {deliveringOrder}
                </Text>
              </TouchableOpacity>
              <TouchableOpacity
                onPress={() => {
                  navigation.navigate('OrderListForReport', {
                    type: 'fail',
                    mode: 1,
                    date: null,
                  });
                }}
                style={{
                  justifyContent: 'center',
                  gap: 7,
                  alignItems: 'center',
                }}>
                <Text style={{fontSize: 16, fontWeight: '500'}}>
                  Đơn thất bại
                </Text>
                <Text
                  style={{fontSize: 14, fontWeight: 'bold', color: 'black'}}>
                  {failDeliveredOrder}
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
        <View style={styles.body}>
          <Text
            style={{
              fontSize: 18,
              fontWeight: 'bold',
              color: 'black',
              marginBottom: '6%',
              marginTop: '25%',
            }}>
            Danh sách nhân viên giao hàng
          </Text>

          {deliverReportList?.length === 0 ? (
            <View style={{alignItems: 'center', justifyContent: 'center'}}>
              <Image
                style={{width: '100%', height: '40%'}}
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
                Không có nhân viên giao hàng nào
              </Text>
            </View>
          ) : (
            <ScrollView
              showsVerticalScrollIndicator={false}
              showsHorizontalScrollIndicator={false}
              contentContainerStyle={{paddingBottom: 80}}>
              {deliverReportList?.map((item, index) => (
                <Pressable
                  key={index}
                  style={{
                    marginBottom: '6%',
                    backgroundColor: 'rgb(240,240,240)',
                    padding: '5%',
                    borderRadius: 10,
                    shadowColor: '#000',
                    shadowOffset: {
                      width: 0,
                      height: 3,
                    },
                    shadowOpacity: 0.27,
                    shadowRadius: 4.65,
                    elevation: 6,
                    margin: 4,
                  }}>
                  <View style={{borderBottomWidth: 0.4, paddingBottom: 10}}>
                    <Text
                      style={{fontSize: 16, fontWeight: '500', color: 'black'}}>
                      Nhân viên: {item.staff.fullName}
                    </Text>
                  </View>
                  <View
                    style={{
                      position: 'absolute',
                      right: 18,
                      top: 8,
                    }}>
                    <Image
                      style={{
                        width: 35,
                        height: 35,
                        borderRadius: 40,
                      }}
                      resizeMode="contain"
                      source={{
                        uri: `${item?.staff.avatarUrl}`,
                      }}
                    />
                  </View>
                  <View
                    style={{
                      flexDirection: 'column',
                      paddingTop: 10,
                      gap: 7,
                    }}>
                    <View
                      style={{
                        flexDirection: 'row',
                        gap: 7,
                        alignItems: 'center',
                      }}>
                      <Text style={{fontSize: 16, fontWeight: '500'}}>
                        Đơn đã giao thành công :{' '}
                      </Text>
                      <Text style={{fontSize: 16, fontWeight: '500'}}>
                        {item.successDeliveredOrder}
                      </Text>
                    </View>
                    <View
                      style={{
                        flexDirection: 'row',
                        gap: 7,
                        alignItems: 'center',
                      }}>
                      <Text style={{fontSize: 16, fontWeight: '500'}}>
                        Đơn giao thất bại :{' '}
                      </Text>
                      <Text style={{fontSize: 16, fontWeight: '500'}}>
                        {item.failDeliveredOrder}
                      </Text>
                    </View>
                  </View>
                </Pressable>
              ))}
            </ScrollView>
          )}
        </View>
        {loading && <LoadingScreen />}
      </View>
    </TouchableWithoutFeedback>
  );
};

export default ReportForManager;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'white',
  },
  header: {
    flex: 1,
    backgroundColor: COLORS.secondary,
    borderBottomLeftRadius: 30,
    borderBottomRightRadius: 30,
    paddingHorizontal: 20,
  },
  body: {
    flex: 4,
    // backgroundColor: 'pink',
    paddingHorizontal: 20,
  },
  pagenameAndLogout: {
    paddingTop: 18,
    flexDirection: 'row',
    alignItems: 'center',
  },
  pageName: {
    flex: 7,
    // backgroundColor: 'white',
  },
  logout: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'flex-end',
    marginLeft: 10,
  },
});
