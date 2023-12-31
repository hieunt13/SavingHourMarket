import React, {useState, useCallback} from 'react';
import {
  View,
  Image,
  Text,
  StyleSheet,
  TouchableWithoutFeedback,
  Keyboard,
} from 'react-native';
import {ScrollView, TouchableOpacity} from 'react-native-gesture-handler';
import {icons} from '../../constants';
import {COLORS} from '../../constants/theme';
import {useFocusEffect} from '@react-navigation/native';
import {format} from 'date-fns';
import LoadingScreen from '../../components/LoadingScreen';
import CartEmpty from '../../assets/image/search-empty.png';
import {checkSystemState} from '../../common/utils';

const BatchingDetail = ({navigation, route}) => {
  // listen to system state
  useFocusEffect(
    useCallback(() => {
      checkSystemState(navigation);
    }, []),
  );

  const {orderList, date, timeFrame, productConsolidationArea, quantity} = route.params;
  const [initializing, setInitializing] = useState(true);
  const [tokenId, setTokenId] = useState(null);
  const [loading, setLoading] = useState(false);

  // const onAuthStateChange = async userInfo => {
  //   setLoading(true);
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
  //       setLoading(false);
  //       return;
  //     }

  //     const token = await auth().currentUser.getIdToken();
  //     setTokenId(token);
  //     setLoading(false);
  //   } else {
  //     // no sessions found.
  //     console.log('user is not logged in');
  //     setLoading(false);
  //   }
  // };

  // useEffect(() => {
  //   // auth().currentUser.reload()
  //   const subscriber = auth().onAuthStateChanged(
  //     async userInfo => await onAuthStateChange(userInfo),
  //   );
  //   return subscriber;
  //   // eslint-disable-next-line react-hooks/exhaustive-deps
  // }, []);

  return (
    <TouchableWithoutFeedback
      onPress={() => {
        Keyboard.dismiss;
        // setOpen(false);
        // setShowLogout(false);
      }}
      accessible={false}>
      <View style={styles.container}>
        <View style={styles.header}>
          <View style={styles.pagenameAndLogout}>
            <TouchableOpacity
              onPress={() =>
                navigation.navigate('BatchList', {
                  isGoBackFromBatchingDetail: true,
                  date: date, 
                  timeFrame: timeFrame, 
                  productConsolidationArea: productConsolidationArea, 
                  quantity: quantity
                })
              }>
              <Image
                source={icons.leftArrow}
                resizeMode="contain"
                style={{width: 35, height: 35, tintColor: COLORS.primary}}
              />
            </TouchableOpacity>
            <View style={styles.pageName}>
              <Text style={{fontSize: 25, color: 'black', fontWeight: 'bold'}}>
                Chi tiết nhóm đơn
              </Text>
            </View>
          </View>
        </View>
        <View style={styles.body}>
          {/* Order list */}
          {orderList.length === 0 ? (
            <View style={{alignItems: 'center', justifyContent: 'center'}}>
              <Image
                style={{width: '100%', height: '50%'}}
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
                Chưa có nhóm đơn hàng nào
              </Text>
            </View>
          ) : (
            <ScrollView
              showsVerticalScrollIndicator={false}
              showsHorizontalScrollIndicator={false}
              contentContainerStyle={{marginTop: 10}}>
              <View style={{marginBottom: 10}}>
                <View style={{marginBottom: 10}}>
                  <Text
                    style={{fontSize: 20, fontWeight: '500', color: 'black'}}>
                    Danh sách đơn hàng :
                  </Text>
                </View>
                {orderList.map(item => (
                  <View
                    key={item.id}
                    style={{
                      backgroundColor: 'rgb(240,240,240)',
                      marginBottom: 20,
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
                    {/* Order detail */}
                    <TouchableOpacity
                      onPress={() => {
                        console.log(item.id);
                        navigation.navigate('OrderDetailForManager', {
                          id: item.id,
                          orderSuccess: false,
                        });
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
                            Đơn hàng
                          </Text>
                          <Text
                            style={{
                              fontSize: 17,
                              fontWeight: 'bold',
                              fontFamily: 'Roboto',
                              color: 'black',
                            }}>
                            Ngày đặt :{' '}
                            {format(
                              Date.parse(item?.createdTime),
                              'dd/MM/yyyy',
                            )}
                          </Text>
                          <Text
                            style={{
                              fontSize: 17,
                              fontWeight: 'bold',
                              fontFamily: 'Roboto',
                              color: 'black',
                            }}>
                            Ngày giao :{' '}
                            {format(
                              Date.parse(item?.deliveryDate),
                              'dd/MM/yyyy',
                            )}
                          </Text>
                          <Text
                            style={{
                              fontSize: 17,
                              fontWeight: 'bold',
                              fontFamily: 'Roboto',
                              color: 'black',
                            }}>
                            Địa chỉ : {item?.addressDeliver}
                          </Text>
                          <Text
                            style={{
                              fontSize: 17,
                              fontWeight: 'bold',
                              fontFamily: 'Roboto',
                              color: 'black',
                            }}>
                            Tổng tiền:{' '}
                            {(item.totalPrice - item.totalDiscountPrice + item.shippingFee).toLocaleString('vi-VN', {
                              style: 'currency',
                              currency: 'VND',
                            })}
                          </Text>
                        </View>
                      </View>
                    </TouchableOpacity>
                    {/* *********************** */}
                  </View>
                ))}
              </View>
            </ScrollView>
          )}
          {/* ************************ */}
        </View>
        {loading && <LoadingScreen />}
      </View>
    </TouchableWithoutFeedback>
  );
};

export default BatchingDetail;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'white',
  },
  header: {
    flex: 1,
    // backgroundColor: 'orange',
    paddingHorizontal: 20,
  },
  body: {
    flex: 10,
    // backgroundColor: 'pink',
    paddingHorizontal: 20,
  },
  pagenameAndLogout: {
    paddingTop: 18,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 20,
  },
  pageName: {
    flex: 7,
    // backgroundColor: 'white',
  },
});
