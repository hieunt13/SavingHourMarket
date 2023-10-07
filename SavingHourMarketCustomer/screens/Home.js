/* eslint-disable prettier/prettier */
/* eslint-disable react-native/no-inline-styles */
/* eslint-disable react/no-unstable-nested-components */
import React, {useCallback, useEffect, useState} from 'react';
import {
  Text,
  View,
  StyleSheet,
  SafeAreaView,
  Image,
  TouchableOpacity,
  ScrollView,
} from 'react-native';
import Categories from '../components/Categories';
import DiscountRow from '../components/DiscountRow';
import {COLORS, FONTS} from '../constants/theme';
import {icons} from '../constants';
import dayjs from 'dayjs';
import AsyncStorage from '@react-native-async-storage/async-storage';
import {API} from '../constants/api';
import {useFocusEffect} from '@react-navigation/native';
import Toast from 'react-native-toast-message';
import LoadingScreen from '../components/LoadingScreen';
import {Alert} from 'react-native';
import messaging from '@react-native-firebase/messaging';

const Home = ({navigation}) => {
  const [categories, setCategories] = useState([]);
  const [subCategories, setSubCategories] = useState([]);
  const [currentCate, setCurrentCate] = useState('');
  const [productsByCategory, setProductsByCategory] = useState([]);
  const [discountsByCategory, setDiscountsByCategory] = useState([]);
  const [page, setPage] = useState(1);
  const [totalPage, setTotalPage] = useState(0);
  const [cartList, setCartList] = useState([]);

  const showToast = () => {
    Toast.show({
      type: 'success',
      text1: 'Thành công',
      text2: 'Thêm sản phẩm vào giỏ hàng thành công 👋',
      duration: 500,
    });
  };

  useFocusEffect(
    useCallback(() => {
      (async () => {
        try {
          const cartList = await AsyncStorage.getItem('CartList');
          setCartList(cartList ? JSON.parse(cartList) : []);
        } catch (err) {
          console.log(err);
        }
      })();
    }, []),
  );

  useEffect(() => {
    fetch(`${API.baseURL}/api/product/getAllCategory`)
      .then(res => res.json())
      .then(data => {
        setCategories(data);
        setCurrentCate(data[0].id);
      })
      .catch(err => {
        console.log(err);
      });
  }, []);

  useEffect(() => {
    if (currentCate) {
      fetch(
        `${API.baseURL}/api/product/getProductsForCustomer?productCategoryId=${currentCate}&page=0&limit=5&quantitySortType=DESC&expiredSortType=ASC`,
      )
        .then(res => res.json())
        .then(data => {
          setProductsByCategory(data);
        })
        .catch(err => {
          console.log(err);
        });

      fetch(
        `${API.baseURL}/api/discount/getDiscountsForCustomer?fromPercentage=0&toPercentage=100&productCategoryId=${currentCate}&page=0&limit=5&expiredSortType=ASC`,
      )
        .then(res => res.json())
        .then(data => {
          setDiscountsByCategory(data);
        })
        .catch(err => {
          console.log(err);
        });
      categories.map(item => {
        item.id === currentCate && setSubCategories(item.productSubCategories);
      });
    }
  }, [currentCate, categories]);

  const handleAddToCart = async data => {
    try {
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

      const cartData = {...data, isChecked: false, cartQuantity: 1};
      newCartList = [...newCartList, cartData];
      setCartList(newCartList);
      await AsyncStorage.setItem('CartList', JSON.stringify(newCartList));
      showToast();
    } catch (error) {
      console.log(error);
    }
  };

  const Item = ({data}) => {
    return (
      <TouchableOpacity
        key={data.id}
        onPress={() => {
          navigation.navigate('ProductDetails', {
            product: data,
          });
        }}>
        <View style={styles.itemContainer}>
          {/* Image Product */}
          <Image
            resizeMode="contain"
            source={{
              uri: data?.imageUrl,
            }}
            style={styles.itemImage}
          />

          <View style={{justifyContent: 'center', flex: 1, marginRight: 10}}>
            <Text
              numberOfLines={1}
              style={{
                fontFamily: FONTS.fontFamily,
                fontSize: 18,
                fontWeight: 700,
                maxWidth: '95%',
                color: 'black',
              }}>
              {data.name}
            </Text>

            <View style={{flexDirection: 'row'}}>
              <Text
                style={{
                  maxWidth: '70%',
                  fontSize: 18,
                  lineHeight: 30,
                  color: COLORS.secondary,
                  fontWeight: 600,
                  fontFamily: FONTS.fontFamily,
                }}>
                {data.price.toLocaleString('vi-VN', {
                  currency: 'VND',
                })}
              </Text>
              <Text
                style={{
                  fontSize: 12,
                  lineHeight: 18,
                  color: COLORS.secondary,
                  fontWeight: 600,
                  fontFamily: FONTS.fontFamily,
                }}>
                ₫
              </Text>
            </View>

            <Text
              style={{
                fontFamily: FONTS.fontFamily,
                fontSize: 18,
                marginBottom: 10,
              }}>
              HSD: {dayjs(data.expiredDate).format('DD/MM/YYYY')}
            </Text>
            {/* Button buy */}
            <TouchableOpacity onPress={() => handleAddToCart(data)}>
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
            </TouchableOpacity>
          </View>
        </View>
      </TouchableOpacity>
    );
  };

  const SubCategory = ({data}) => {
    return (
      <View
        style={{
          marginTop: 20,
          marginLeft: 15,
          marginRight: 25,
          alignItems: 'center',
          maxWidth: 80,
        }}>
        <Image
          resizeMode="contain"
          source={{
            uri: data?.imageUrl,
          }}
          style={{
            width: 65,
            height: 65,
          }}
        />
        <Text
          style={{
            color: 'black',
            fontFamily: FONTS.fontFamily,
            fontSize: 14,
            marginTop: 8,
            textAlign: 'center',
          }}>
          {data.name}
        </Text>
      </View>
    );
  };

  const SearchBar = () => {
    return (
      <TouchableOpacity
        style={{
          backgroundColor: '#f5f5f5',
          width: '80%',
          height: 45,
          borderRadius: 40,
          paddingLeft: 10,
          marginTop: 10,
          marginLeft: 20,
          marginBottom: 10,
          flexDirection: 'row',
        }}
        onPress={() => {
          navigation.navigate('Search');
        }}>
        <View
          style={{
            justifyContent: 'center',
            alignItems: 'center',
            height: 40,
            flexWrap: 'wrap',
            paddingLeft: 5,
            paddingTop: 2,
          }}>
          <Image
            resizeMode="contain"
            style={{
              width: 20,
              height: 20,
            }}
            source={icons.search}
          />

          <Text
            style={{
              fontFamily: FONTS.fontFamily,
              fontSize: 16,
              paddingLeft: 15,
            }}>
            Bạn cần tìm gì ?
          </Text>
        </View>
      </TouchableOpacity>
    );
  };

  return (
    <SafeAreaView style={styles.container}>
      {/* Search */}
      <View style={{flexDirection: 'row', gap: 10, alignItems: 'center'}}>
        <SearchBar />
        <TouchableOpacity
          onPress={() => {
            navigation.navigate('Cart');
          }}>
          <Image
            resizeMode="contain"
            style={{
              height: 40,
              tintColor: COLORS.primary,
              width: 35,
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
                style={{fontSize: 12, color: 'white', fontFamily: 'Roboto'}}>
                {cartList.length}
              </Text>
            </View>
          )}
        </TouchableOpacity>
      </View>

      {/* Body */}
      <ScrollView
        keyboardShouldPersistTaps="always"
        contentContainerStyle={{
          paddingBottom: 100,
        }}>
        {/* Categories */}
        <Categories
          categories={categories}
          currentCate={currentCate}
          setCurrentCate={setCurrentCate}
        />

        {/* Sub-Categories */}
        <View
          style={{
            flex: 1,
            flexDirection: 'row',
            flexWrap: 'wrap',
            marginVertical: 5,
          }}>
          {subCategories.map((item, index) => (
            <SubCategory data={item} key={index} />
          ))}
        </View>

        {!discountsByCategory.length == 0 ? (
          <>
            {/* Sale, Discount */}
            <View
              style={{
                flexDirection: 'row',
                justifyContent: 'space-between',
                marginHorizontal: 20,
              }}>
              <Text
                style={{
                  fontFamily: FONTS.fontFamily,
                  fontSize: 22,
                  color: 'black',
                  fontWeight: 700,
                  marginTop: '5%',
                  marginBottom: 10,
                }}>
                Khuyến Mãi Cực Sốc
              </Text>

              <TouchableOpacity
                style={{
                  marginTop: '5%',
                }}
                onPress={() => {
                  navigation.navigate('Discount');
                }}>
                <Text
                  style={{
                    fontFamily: FONTS.fontFamily,
                    fontSize: 22,
                    color: COLORS.primary,
                    fontWeight: 700,
                    marginBottom: 10,
                  }}>
                  Tất cả
                </Text>
              </TouchableOpacity>
            </View>
            <DiscountRow discounts={discountsByCategory} />
          </>
        ) : (
          <></>
        )}
        {/* List Product */}
        <Text
          style={{
            fontFamily: FONTS.fontFamily,
            fontSize: 22,
            color: 'black',
            fontWeight: 700,
            marginLeft: 20,
            marginTop: '5%',
            marginBottom: 10,
          }}>
          Danh sách sản phẩm
        </Text>

        {productsByCategory.map((item, index) => (
          <Item data={item} key={index} />
        ))}
        {/* Load more Products */}
        {page < totalPage && (
          <TouchableOpacity>
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
      </ScrollView>
    </SafeAreaView>
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
    marginHorizontal: '5%',
    marginBottom: 20,
    flexDirection: 'row',
  },
  itemImage: {
    width: 130,
    height: 130,
    borderRadius: 20,
    padding: 10,
    margin: 15,
  },
  itemText: {
    fontFamily: FONTS.fontFamily,
    fontSize: 20,
  },
});

export default Home;
