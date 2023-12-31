/* eslint-disable prettier/prettier */
// eslint-disable-next-line prettier/prettier
import {
  View,
  Text,
  TouchableOpacity,
  Image,
  StyleSheet,
  TextInput,
  FlatList,
  Dimensions,
  Modal as FilterModal,
} from 'react-native';
import React, { useState, useRef, useCallback } from 'react';
import { icons } from '../constants';
import { COLORS, FONTS } from '../constants/theme';
import dayjs from 'dayjs';
import Empty from '../assets/image/search-empty.png';
import { API } from '../constants/api';
import { useFocusEffect } from '@react-navigation/native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import Toast from 'react-native-toast-message';
import LoadingScreen from '../components/LoadingScreen';
import Modal, {
  ModalFooter,
  ModalButton,
  ScaleAnimation,
} from 'react-native-modals';
import database from '@react-native-firebase/database';

const SearchResult = ({ navigation, route }) => {
  const [result, setResult] = useState(route.params.result);
  const [productName, setProductName] = useState(route.params.text);
  const [text, setText] = useState(route.params.text);
  const [cartList, setCartList] = useState([]);
  const [modalVisible, setModalVisible] = useState(false);
  const [currentCate, setCurrentCate] = useState('');
  const [loading, setLoading] = useState(false);
  const [selectFilter, setSelectFilter] = useState([]);
  const [openAuthModal, setOpenAuthModal] = useState(false);
  const sortOptions = [
    {
      id: 1,
      name: 'HSD gần nhất',
      active: false,
    },
    {
      id: 2,
      name: 'HSD xa nhất',
      active: false,
    },
    {
      id: 3,
      name: 'Giá tiền tăng dần',
      active: false,
    },
    {
      id: 4,
      name: 'Giá tiền giảm dần',
      active: false,
    },
  ];
  const [selectFilterInit, setSelectFilterInit] = useState([]);
  const [selectSort, setSelectSort] = useState(sortOptions);
  const searchHistory = route.params.text;
  const [pickupPoint, setPickupPoint] = useState({
    id: 'accf0ac0-5541-11ee-8a50-a85e45c41921',
    address: 'Hẻm 662 Nguyễn Xiển, Long Thạnh Mỹ, Thủ Đức, Hồ Chí Minh',
    status: 1,
    longitude: 106.83102962168277,
    latitude: 10.845020092805793,
  });
  const [page, setPage] = useState(1);
  const [totalPage, setTotalPage] = useState(1);
  const [sortItemSelected, setSortItemSelected] = useState(null);

  const showToast = () => {
    Toast.show({
      type: 'success',
      text1: 'Thành công',
      text2: 'Thêm sản phẩm vào giỏ hàng thành công 👋',
      visibilityTime: 500,
    });
  };

  const typingTimeoutRef = useRef(null);

  const handleTypingSearch = value => {
    if (typingTimeoutRef.current) {
      clearTimeout(typingTimeoutRef.current);
    }
    typingTimeoutRef.current = setTimeout(() => {
      setProductName(value);
    }, 400);
  };

  const handleClearText = () => {
    setText('');
    handleTypingSearch('');
  };

  const sortProduct = item => {
    const sortItem = item.find(item => item.active === true);
    setSortItemSelected(sortItem);
    setLoading(true);
    if (sortItem) {
      fetch(
        `${API.baseURL}/api/product/getProductsForCustomer?name=${encodeURIComponent(productName)}${currentCate === '' ? '' : '&productCategoryId=' + currentCate
        }&page=0&limit=10${sortItem?.id == 1 ? '&expiredSortType=ASC' : ''}${sortItem?.id == 2 ? '&expiredSortType=DESC' : ''
        }${sortItem?.id == 3 ? '&priceSort=ASC' : ''}${sortItem?.id == 4 ? '&priceSort=DESC' : ''
        }&pickupPointId=${pickupPoint.id}`,
      )
        .then(res => res.json())
        .then(data => {
          setResult(data.productList);
          setPage(1);
          setTotalPage(data.totalPage);
          setLoading(false);
        })
        .catch(err => {
          console.log(err);
          setLoading(false);
        });
    } else {
      fetch(
        `${API.baseURL}/api/product/getProductsForCustomer?name=${encodeURIComponent(productName)}${currentCate === '' ? '' : '&productCategoryId=' + currentCate
        }&page=0&limit=10&pickupPointId=${pickupPoint.id}`,
      )
        .then(res => res.json())
        .then(data => {
          setResult(data.productList);
          setPage(1);
          setTotalPage(data.totalPage);
          setLoading(false);
        })
        .catch(err => {
          console.log(err);
          setLoading(false);
        });
    }
  };

  // system status check
  useFocusEffect(
    useCallback(() => {
      database().ref(`systemStatus`).off('value');
      database()
        .ref('systemStatus')
        .on('value', async snapshot => {
          if (snapshot.val() === 0) {
            navigation.reset({
              index: 0,
              routes: [{ name: 'Initial' }],
            });
          } else {
            // setSystemStatus(snapshot.val());
          }
        });
    }, []),
  );

  const handleApplyFilter = () => {
    setModalVisible(!modalVisible);
    setLoading(true);
    sortProduct(selectSort);
  };

  const handleClear = () => {
    setModalVisible(!modalVisible);
    setCurrentCate('');
    setSortItemSelected(null);
    setLoading(true);
    fetch(
      `${API.baseURL}/api/product/getProductsForCustomer?name=${encodeURIComponent(productName)}&pickupPointId=${pickupPoint.id}&page=0&limit=10`,
    )
      .then(res => res.json())
      .then(data => {
        setResult(data.productList);
        setPage(1);
        setTotalPage(data.totalPage);
        setSelectSort(sortOptions);
        setSelectFilter(selectFilterInit);
        setLoading(false);
      })
      .catch(err => {
        console.log(err);
        setLoading(false);
      });
  };

  const handleAddToCart = async data => {
    try {
      const user = await AsyncStorage.getItem('userInfo');
      if (!user) {
        setOpenAuthModal(true);
        return;
      }
      const jsonValue = await AsyncStorage.getItem('CartList');
      let newCartList = jsonValue ? JSON.parse(jsonValue) : [];
      const itemExisted = newCartList.some(item => item.id === data.id);
      if (itemExisted) {
        const index = newCartList.findIndex(item => item.id === data.id);
        newCartList[index].cartQuantity = newCartList[index].cartQuantity + 1;
        setCartList(newCartList);
        await AsyncStorage.setItem('CartList', JSON.stringify(newCartList));
        showToast();
        return;
      }

      const cartData = { ...data, isChecked: false, cartQuantity: 1 };
      newCartList = [...newCartList, cartData];
      setCartList(newCartList);
      await AsyncStorage.setItem('CartList', JSON.stringify(newCartList));
      showToast();
    } catch (error) {
      console.log(error);
    }
  };

  const handleStoredSearchHistory = async data => {
    try {
      const value = await AsyncStorage.getItem('SearchHistory');
      let newSearchHistoryList = value ? JSON.parse(value) : [];
      const isExisted = newSearchHistoryList.some(item => item == data);
      if (isExisted) {
        const index = newSearchHistoryList.findIndex(item => item == data);
        console.log(index);
        newSearchHistoryList.splice(index, 1);
        newSearchHistoryList.unshift(data);
        await AsyncStorage.setItem(
          'SearchHistory',
          JSON.stringify(newSearchHistoryList),
        );
      } else {
        const searchData = newSearchHistoryList.unshift(searchHistory);
        await AsyncStorage.setItem('SearchHistory', JSON.stringify(searchData));
      }
      setLoading(false);
    } catch (err) {
      setLoading(false);
      console.log(err);
    }
  };

  // fetch search suggestion
  useFocusEffect(
    useCallback(() => {
      setLoading(true);
      // AsyncStorage.removeItem('SearchHistory');
      // Get pickup point from AS
      (async () => {
        try {
          const value = await AsyncStorage.getItem('PickupPoint');
          const id = value ? JSON.parse(value).id : pickupPoint.id;
          const cartList = await AsyncStorage.getItem('CartList' + id);
          setCartList(cartList ? JSON.parse(cartList) : []);
          setPickupPoint(JSON.parse(value));
          fetch(
            `${API.baseURL
            }/api/product/getProductsForCustomer?name=${encodeURIComponent(productName)}&pickupPointId=${JSON.parse(value).id
            }&page=0&limit=10`,
          )
            .then(res => res.json())
            .then(data => {
              setResult(data.productList);
              setPage(1);
              setTotalPage(data.totalPage);
              setLoading(false);
            })
            .catch(err => {
              console.log(err);
              setLoading(false);
            });
        } catch (err) {
          console.log(err);
          setLoading(false);
        }
      })();

      (async () => {
        try {
          const value = await AsyncStorage.getItem('SearchHistory');
          let newSearchHistoryList = value ? JSON.parse(value) : [];
          const isExisted = newSearchHistoryList.some(
            item => item == searchHistory,
          );
          if (isExisted) {
            const index = newSearchHistoryList.findIndex(
              item => item == searchHistory,
            );
            newSearchHistoryList.splice(index, 1);
            newSearchHistoryList.unshift(searchHistory);
            await AsyncStorage.setItem(
              'SearchHistory',
              JSON.stringify(newSearchHistoryList),
            );
            setLoading(false);
            return;
          }
          const searchData = [searchHistory, ...newSearchHistoryList];
          await AsyncStorage.setItem(
            'SearchHistory',
            JSON.stringify(searchData),
          );
          setLoading(false);
        } catch (err) {
          console.log(err);
          setLoading(false);
        }
      })();

      fetch(
        `${API.baseURL}/api/product/getAllCategory?pickupPointId=${pickupPoint.id}`,
      )
        .then(res => res.json())
        .then(data => {
          const cateData = data.map(item => {
            return { ...item, active: false };
          });
          setSelectFilter(cateData);
          setSelectFilterInit(cateData);
          setLoading(false);
        })
        .catch(err => {
          console.log(err);
          setLoading(false);
        });
    }, [pickupPoint.id, productName, searchHistory]),
  );

  const Product = ({ data }) => {
    return (
      <View style={styles.itemContainer}>
        <TouchableOpacity
          key={data.id}
          onPress={() => {
            navigation.navigate('ProductDetails', {
              product: data,
              pickupPointId: pickupPoint.id,
            });
          }}
          style={{
            flexDirection: 'row',
            width: '100%',
          }}
        >
          {/* Image Product */}
          <Image
            resizeMode="contain"
            source={{
              uri: data?.imageUrlImageList[0].imageUrl,
            }}
            style={styles.itemImage}
          />

          <View
            style={{
              justifyContent: 'center',
              flex: 1,
              marginRight: 10,
              marginTop: 5,
            }}>
            <Text
              numberOfLines={1}
              style={{
                fontFamily: FONTS.fontFamily,
                fontSize: Dimensions.get('window').width * 0.05,
                fontWeight: 700,
                maxWidth: '95%',
                color: 'black',
              }}>
              {data.name}
            </Text>
            <Text
              style={{
                fontFamily: FONTS.fontFamily,
                fontSize: Dimensions.get('window').width * 0.045,
                marginTop: 8,
                marginBottom: 10,
              }}>
              HSD:{' '}
              {dayjs(data?.nearestExpiredBatch.expiredDate).format(
                'DD/MM/YYYY',
              )}
            </Text>
            <View style={{ flexDirection: 'row', paddingBottom: '2%', }}>
              <Text
                style={{
                  maxWidth: '70%',
                  fontSize: Dimensions.get('window').width * 0.035,
                  lineHeight: 20,
                  fontWeight: 'bold',
                  fontFamily: FONTS.fontFamily,
                  textDecorationLine: 'line-through'
                }}>
                {data?.priceListed.toLocaleString('vi-VN', {
                  currency: 'VND',
                })}
              </Text>
              <Text
                style={{
                  fontSize: Dimensions.get('window').width * 0.03,
                  lineHeight: 13,
                  fontWeight: 600,
                  fontFamily: FONTS.fontFamily,
                }}>
                ₫
              </Text>
            </View>

            <View style={{ flexDirection: 'row' }}>
              <Text
                style={{
                  maxWidth: '70%',
                  fontSize: Dimensions.get('window').width * 0.045,
                  lineHeight: 20,
                  color: COLORS.secondary,
                  fontWeight: 'bold',
                  fontFamily: FONTS.fontFamily,
                }}>
                {data?.nearestExpiredBatch.price.toLocaleString('vi-VN', {
                  currency: 'VND',
                })}
              </Text>
              <Text
                style={{
                  fontSize: Dimensions.get('window').width * 0.03,
                  lineHeight: 13,
                  color: COLORS.secondary,
                  fontWeight: 600,
                  fontFamily: FONTS.fontFamily,
                }}>
                ₫
              </Text>
            </View>

            {/* Button buy */}
            {/* <TouchableOpacity onPress={() => handleAddToCart(data)}>
            <Text
              style={{
                maxWidth: 150,
                maxHeight: 40,
                padding: 10,
                backgroundColor: COLORS.primary,
                borderRadius: 10,
                textAlign: 'center',
                color: '#ffffff',
                fontFamily: FONTS.fontFamily,
              }}>
              Thêm vào giỏ hàng
            </Text>
          </TouchableOpacity> */}
          </View>
        </TouchableOpacity>
      </View>
    );
  };

  const ModalSortItem = ({ item }) => {
    return (
      <TouchableOpacity
        onPress={() => {
          const newArray = selectSort.map(i => {
            if (i.id === item.id) {
              if (i.active === true) {
                return { ...i, active: false };
              } else {
                return { ...i, active: true };
              }
            }
            return { ...i, active: false };
          });
          setSelectSort(newArray);
        }}
        style={
          item.active == true
            ? {
              borderColor: COLORS.primary,
              borderWidth: 1,
              borderRadius: 10,
              margin: 5,
            }
            : {
              borderColor: '#c8c8c8',
              borderWidth: 0.2,
              borderRadius: 10,
              margin: 5,
            }
        }>
        <Text
          style={
            item.active == true
              ? {
                width: Dimensions.get('window').width * 0.35,
                paddingHorizontal: '5%',
                paddingVertical: 10,
                textAlign: 'center',
                color: COLORS.primary,
                fontFamily: FONTS.fontFamily,
                fontSize: Dimensions.get('window').width * 0.03,
              }
              : {
                width: Dimensions.get('window').width * 0.35,
                paddingHorizontal: '5%',
                paddingVertical: 10,
                textAlign: 'center',
                color: 'black',
                fontFamily: FONTS.fontFamily,
                fontSize: Dimensions.get('window').width * 0.03,
              }
          }>
          {item.name}
        </Text>
      </TouchableOpacity>
    );
  };

  const ModalCateItem = ({ item }) => {
    return (
      <TouchableOpacity
        onPress={() => {
          setCurrentCate(item.id);
          const newArray = selectFilter.map(i => {
            if (i.id === item.id) {
              if (i.active === true) {
                setCurrentCate('');
                return { ...i, active: false };
              } else {
                return { ...i, active: true };
              }
            }
            return { ...i, active: false };
          });
          setSelectFilter(newArray);
        }}
        style={
          item.active == true
            ? {
              borderColor: COLORS.primary,
              borderWidth: 1,
              borderRadius: 10,
              margin: 5,
            }
            : {
              borderColor: '#c8c8c8',
              borderWidth: 0.2,
              borderRadius: 10,
              margin: 5,
            }
        }>
        <Text
          style={
            item.active == true
              ? {
                width: Dimensions.get('window').width * 0.35,
                paddingHorizontal: '4%',
                paddingVertical: 10,
                textAlign: 'center',
                color: COLORS.primary,
                fontFamily: FONTS.fontFamily,
                fontSize: Dimensions.get('window').width * 0.03,
              }
              : {
                width: Dimensions.get('window').width * 0.35,
                paddingHorizontal: '4%',
                paddingVertical: 10,
                textAlign: 'center',
                color: 'black',
                fontFamily: FONTS.fontFamily,
                fontSize: Dimensions.get('window').width * 0.03,
              }
          }>
          {item.name}
        </Text>
      </TouchableOpacity>
    );
  };

  const LoadMoreButton = () => {
    return (
      <>
        {page < totalPage && (
          <TouchableOpacity
            onPress={() => {
              setPage(page + 1);
              setLoading(true);
              fetch(
                `${API.baseURL
                }/api/product/getProductsForCustomer?name=${encodeURIComponent(productName)}${currentCate === '' ? '' : '&productCategoryId=' + currentCate
                }&pickupPointId=${pickupPoint?.id}&page=${page
                }&limit=10${sortItemSelected?.id == 1 ? '&expiredSortType=ASC' : ''}${sortItemSelected?.id == 2 ? '&expiredSortType=DESC' : ''
                }${sortItemSelected?.id == 3 ? '&priceSort=ASC' : ''}${sortItemSelected?.id == 4 ? '&priceSort=DESC' : ''
                }`,
              )
                .then(res => res.json())
                .then(data => {
                  setResult([
                    ...result,
                    ...data.productList,
                  ]);
                  setTotalPage(data.totalPage);
                  setLoading(false);
                })
                .catch(err => {
                  console.log(err);
                  setLoading(false);
                });
            }}>
            <Text
              style={{
                backgroundColor: COLORS.light_green,
                color: COLORS.primary,
                borderColor: COLORS.primary,
                borderWidth: 1,
                paddingVertical: 10,
                width: '40%',
                borderRadius: 20,
                textAlign: 'center',
                marginLeft: '30%',
              }}>
              Xem thêm sản phẩm
            </Text>
          </TouchableOpacity>
        )}
      </>
    )
  }

  return (
    <View
      style={{
        backgroundColor: '#fff',
        minHeight: '100%',
        paddingBottom: 80,
      }}>
      <View
        style={{
          flexDirection: 'row',
          alignItems: 'center',
          paddingLeft: '2%',
          marginBottom: 20,
        }}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <Image
            source={icons.leftArrow}
            resizeMode="contain"
            style={{ width: 35, height: 35, tintColor: COLORS.primary }}
          />
        </TouchableOpacity>

        <View style={styles.containerSearch}>
          <View style={styles.wrapperSearch}>
            <Image
              resizeMode="center"
              style={styles.icon}
              source={icons.search}
            />
          </View>
          <TextInput
            style={styles.input}
            placeholder="Bạn cần tìm gì ?"
            value={text}
            onChangeText={data => {
              setText(data);
              handleTypingSearch(data);
            }}
            onSubmitEditing={() => {
              setSelectSort(sortOptions);
              setSelectFilter(selectFilterInit);
              if (productName != '') {
                handleStoredSearchHistory(productName);
              }
            }}
          />
          <View style={styles.clear}>
            <TouchableOpacity onPress={handleClearText}>
              <Image
                resizeMode="center"
                style={styles.icon}
                source={icons.clearText}></Image>
            </TouchableOpacity>
          </View>
        </View>

        <TouchableOpacity
          onPress={() => {
            setModalVisible(true);
          }}>
          <Image
            resizeMode="contain"
            style={{
              height: 35,
              tintColor: COLORS.primary,
              width: Dimensions.get('window').width * 0.1,
              marginHorizontal: '1%',
            }}
            source={icons.filter}
          />
        </TouchableOpacity>

        <TouchableOpacity
          onPress={() => {
            navigation.navigate('Cart');
          }}>
          <Image
            resizeMode="contain"
            style={{
              height: 40,
              tintColor: COLORS.primary,
              width: Dimensions.get('window').width * 0.1,
            }}
            source={icons.cart}
          />
          {cartList.lenght !== 0 && (
            <View
              style={{
                position: 'absolute',
                top: 0,
                right: -10,
                backgroundColor: COLORS.primary,
                borderRadius: 50,
                width: 20,
                height: 20,
                alignItems: 'center',
                justifyContent: 'center',
              }}>
              <Text
                style={{ fontSize: 12, color: 'white', fontFamily: 'Roboto' }}>
                {cartList.length}
              </Text>
            </View>
          )}
        </TouchableOpacity>
      </View>

      {/* Search Result */}
      {result.length == 0 ? (
        <View style={{ alignItems: 'center', marginTop: '20%' }}>
          <Image
            style={{ width: 200, height: 200 }}
            resizeMode="contain"
            source={Empty}
          />
          <Text
            style={{
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: 'bold',
            }}>
            Không tìm thấy sản phẩm
          </Text>
        </View>
      ) : (
        <FlatList
          scrollEnabled={true}
          showsVerticalScrollIndicator={true}
          data={result}
          keyExtractor={item => `${item.id}`}
          renderItem={({ item }) => <Product data={item} />}
          ListFooterComponent={<LoadMoreButton />}
          ListFooterComponentStyle={{
            paddingBottom: Dimensions.get('window').width * 0.05,
          }}
        />
      )}
      {/* Modal filter */}
      <FilterModal
        animationType="fade"
        transparent={true}
        visible={modalVisible}
        onRequestClose={() => {
          setModalVisible(!modalVisible);
        }}>
        <View style={styles.centeredView}>
          <View style={styles.modalView}>
            <View
              style={{
                flexDirection: 'row',
                justifyContent: 'space-between',
              }}>
              <Text
                style={{
                  color: 'black',
                  fontFamily: FONTS.fontFamily,
                  fontSize: Dimensions.get('window').width * 0.05,
                  fontWeight: 700,
                  textAlign: 'center',
                  paddingBottom: 20,
                }}>
                Bộ lọc tìm kiếm
              </Text>
              <TouchableOpacity
                onPress={() => {
                  setModalVisible(!modalVisible);
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
            <Text
              style={{
                color: 'black',
                fontFamily: FONTS.fontFamily,
                fontSize: Dimensions.get('window').width * 0.045,
                fontWeight: 700,
              }}>
              Sắp xếp theo
            </Text>
            <View
              style={{
                flexDirection: 'row',
                flexWrap: 'wrap',
                marginVertical: 10,
                justifyContent: 'center',
              }}>
              {selectSort.map((item, index) => (
                <ModalSortItem item={item} key={index} />
              ))}
            </View>
            <Text
              style={{
                color: 'black',
                fontFamily: FONTS.fontFamily,
                fontSize: Dimensions.get('window').width * 0.045,
                fontWeight: 700,
              }}>
              Lọc theo loại sản phẩm
            </Text>
            <View
              style={{
                flexDirection: 'row',
                flexWrap: 'wrap',
                marginVertical: 10,
                justifyContent: 'center',
              }}>
              {selectFilter.map((item, index) => (
                <ModalCateItem item={item} key={index} />
              ))}
            </View>

            <View
              style={{
                flexDirection: 'row',
                justifyContent: 'center',
                marginTop: '5%',
              }}>
              <TouchableOpacity
                style={{
                  width: '50%',
                  paddingHorizontal: '2%',
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
                    fontSize: Dimensions.get('window').width * 0.035,
                  }}>
                  Thiết lập lại
                </Text>
              </TouchableOpacity>

              <TouchableOpacity
                style={{
                  width: '50%',
                  paddingHorizontal: '2%',
                  paddingVertical: 10,
                  backgroundColor: COLORS.primary,
                  color: 'white',
                  borderRadius: 10,
                }}
                onPress={handleApplyFilter}>
                <Text style={styles.textStyle}>Áp dụng</Text>
              </TouchableOpacity>
            </View>
          </View>
        </View>
      </FilterModal>
      {/* auth modal */}
      <Modal
        width={0.8}
        visible={openAuthModal}
        onTouchOutside={() => {
          setOpenAuthModal(false);
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
              text="Đăng nhập"
              textStyle={{ color: COLORS.primary }}
              onPress={async () => {
                try {
                  await AsyncStorage.clear();
                  navigation.navigate('Login');
                  setOpenAuthModal(false);
                } catch (error) {
                  console.log(error);
                }
              }}
            />
          </ModalFooter>
        }>
        <View
          style={{ padding: 20, alignItems: 'center', justifyContent: 'center' }}>
          <Text
            style={{
              fontSize: 20,
              fontFamily: 'Roboto',
              color: 'black',
              textAlign: 'center',
            }}>
            Vui lòng đăng nhập để thực hiện thao tác này
          </Text>
        </View>
      </Modal>
      {loading && <LoadingScreen />}
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  itemContainer: {
    backgroundColor: '#F5F5F5',
    maxWidth: '90%',
    borderRadius: 20,
    marginHorizontal: '6%',
    marginBottom: 20,
    flexDirection: 'row',

    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 3,
    },
    shadowOpacity: 0.27,
    shadowRadius: 4.65,
    elevation: 2,
  },
  itemImage: {
    width: '40%',
    height: 130,
    borderRadius: 20,
    padding: 10,
    margin: 15,
  },
  itemText: {
    fontFamily: FONTS.fontFamily,
    fontSize: 20,
  },
  containerSearch: {
    backgroundColor: '#f5f5f5',
    width: '60%',
    height: 40,
    borderRadius: 40,
    paddingLeft: 10,
    marginTop: 10,
    marginLeft: '2%',
    marginBottom: 10,
    flexDirection: 'row',
    borderWidth: 1,
    borderColor: COLORS.primary,
  },
  input: {
    fontFamily: FONTS.fontFamily,
    fontSize: 14,
    flex: 1,
  },
  wrapperSearch: {
    justifyContent: 'center',
    alignItems: 'center',
    width: 40,
    height: 40,
    flex: 0.2,
  },
  icon: {
    width: 20,
    height: 20,
  },
  clear: {
    flex: 0.2,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 5,
  },
  centeredView: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: 22,
  },
  modalView: {
    margin: 20,
    backgroundColor: 'white',
    borderRadius: 20,
    padding: '5%',
    shadowColor: '#000',
    shadowOffset: {
      width: 0,
      height: 2,
    },
    shadowOpacity: 0.25,
    shadowRadius: 4,
    elevation: 5,
  },
  button: {
    borderRadius: 20,
    padding: 10,
    elevation: 2,
  },
  buttonOpen: {
    backgroundColor: '#F194FF',
  },
  buttonClose: {
    backgroundColor: '#2196F3',
  },
  textStyle: {
    color: 'white',
    fontWeight: 'bold',
    textAlign: 'center',
    fontSize: Dimensions.get('window').width * 0.035,
  },
  modalText: {
    marginBottom: 15,
    textAlign: 'center',
  },
});

export default SearchResult;
