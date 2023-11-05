/* eslint-disable prettier/prettier */
import React, { useEffect, useState, useCallback } from 'react';
import { View } from 'react-native';
import { createBottomTabNavigator } from '@react-navigation/bottom-tabs';
import TabIcon from '../components/TabIcon';
import Home from '../screens/Home';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { icons } from '../constants';
import { COLORS } from '../constants/theme';
import { useFocusEffect } from '@react-navigation/native';
import Test from '../components/Test';
import Dropdown from '../screens/Dropdown';
import HomeDeliver from '../screens/HomeDeliver';
import QrCodeScanner from '../screens/QrCodeScanner';

const Tab = createBottomTabNavigator();

const Tabs = () => {
  const [user, setUser] = useState(null);

  useFocusEffect(
    useCallback(() => {
      const getUser = async () => {
        const currentUser = await AsyncStorage.getItem('userInfo');
        setUser(currentUser ? JSON.parse(currentUser) : null);
      };
      getUser();
    }, []),
  );

  console.log(user);

  return (
    <Tab.Navigator
      screenOptions={{
        headerShown: false,
        tabBarShowLabel: false,
        tabBarStyle: {
          position: 'absolute',
          bottom: 0,
          left: 0,
          right: 0,
          elevation: 0,
          backgroundColor: COLORS.tabBackground,
          opacity: 0.95,
          borderTopColor: 'transparent',
          height: 80,
        },
      }}>
      {!user && (
        <Tab.Screen
          name="Temp"
          component={Test}
          options={{
            tabBarIcon: ({ focused }) => (
              <TabIcon display={'Order'} focused={focused} icon={icons.home} />
            ),
          }}
        />
      )}

      {user?.role === 'STAFF_ORD' && (
        <>
          <Tab.Screen
            name="Home"
            component={Home}
            options={{
              tabBarIcon: ({ focused }) => (
                <TabIcon
                  display={'Order'}
                  focused={focused}
                  icon={icons.order}
                />
              ),
            }}
          />
          <Tab.Screen
            name="Drop down"
            component={Dropdown}
            options={{
              tabBarIcon: ({ focused }) => (
                <TabIcon
                  display={'Report'}
                  focused={focused}
                  icon={icons.statistic}
                />
              ),
            }}
          />
        </>
      )}
      {user?.role === 'STAFF_DLV_1' && (
        <>
          <Tab.Screen
            name="Home"
            component={Home}
            options={{
              tabBarIcon: ({ focused }) => (
                <TabIcon display={'DLV1'} focused={focused} icon={icons.home} />
              ),
            }}
          />
          <Tab.Screen
            name="Home2"
            component={Home}
            options={{
              tabBarIcon: ({ focused }) => (
                <TabIcon display={'DLV1'} focused={focused} icon={icons.home} />
              ),
            }}
          />
          <Tab.Screen
            name="Home3"
            component={Home}
            options={{
              tabBarIcon: ({ focused }) => (
                <TabIcon display={'DLV1'} focused={focused} icon={icons.home} />
              ),
            }}
          />
        </>
      )}
      {user?.role === 'STAFF_DLV_0' && (
        <>
          <Tab.Screen
            name="HomeDeliver"
            component={HomeDeliver}
            options={{
              tabBarIcon: ({ focused }) => (
                <TabIcon display={'Trang chủ'} focused={focused} icon={icons.home} />
              ),
            }}
          />
          <Tab.Screen
            name="Home2"
            component={QrCodeScanner}
            options={{
              tabBarIcon: ({ focused }) => (
                <TabIcon display={'Scan QR'} focused={focused} icon={icons.qrCodeScanner} />
              ),
            }}
          />
          <Tab.Screen
            name="Home3"
            component={Home}
            options={{
              tabBarIcon: ({ focused }) => (
                <TabIcon display={'DLV0'} focused={focused} icon={icons.home} />
              ),
            }}
          />
        </>
      )}
    </Tab.Navigator>
  );
};

export default Tabs;
